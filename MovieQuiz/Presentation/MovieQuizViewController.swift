import UIKit

final class MovieQuizViewController: UIViewController,
                                     QuestionFactoryDelegate,
                                     AlertPresenterDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var questionUIElementLabel: UILabel!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    
    private var questionFactory: QuestionFactory?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = "Загрузка вопросов..."
        activityIndicator.hidesWhenStopped = true
        
        changeIsHiddenUI(to: true)
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        alertPresenter = AlertPresenter(viewController: self)
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convertQuestionToView(model: question)

        DispatchQueue.main.async { [weak self] in
            self?.showQuizStep(quiz: viewModel)
        }
        
        changeStateButton(isEnabled: true)
    }
    
    func didGetErrorMessageFromApi(with error: String) {
        showApiError(message: error)
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didFailToLoadImage(with error: Error) {
        showImageLoadError(message: error.localizedDescription)
    }
    
    // MARK: - AlertPresenterDelegate
    func didDismissAlert() {
        currentQuestionIndex = 0
        correctAnswers = 0
        
        questionFactory?.requestNextQuestion()
        
        changeStateButton(isEnabled: true)
    }
    
    func didTryLoadDataAgain() {
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - Private functions
    private func changeIsHiddenUI(to value: Bool) {
        imageView.isHidden = value
        counterLabel.isHidden = value
        questionUIElementLabel.isHidden = value
        yesButton.isHidden = value
        noButton.isHidden = value
    }
    
    private func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    private func showApiError(message: String) {
        hideLoadingIndicator()
        let errorMessage: String = message + "\nОбновите либо попробуйте позже"
        
        let model = AlertModelError(
            title: "Ошибка сервера",
            message: errorMessage,
            buttonText: "Обновить"
        ) { [weak self] in
            self?.didTryLoadDataAgain()
        }
        
        alertPresenter?.showAlertError(model: model)
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModelError(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз"
        ) { [weak self] in
            self?.didTryLoadDataAgain()
        }
        
        alertPresenter?.showAlertError(model: model)
    }
    
    private func showImageLoadError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModelError(
            title: "Ошибка изображения",
            message: message,
            buttonText: "Начать заново"
        ) { [weak self] in
            self?.didDismissAlert()
        }
        
        alertPresenter?.showAlertError(model: model)
    }
    
    private func convertQuestionToView(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showQuizStep(quiz step: QuizStepViewModel) {
        changeIsHiddenUI(to: false)
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        
        let colorBorder = isCorrect == true ? UIColor.yGreen : UIColor.yRed
        imageView.layer.borderColor = colorBorder.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            
            statisticService.store(game: GameResult(
                correct: correctAnswers,
                total: questionsAmount,
                date: Date())
            )
            
            let model = AlertModel(
                message: """
                        Ваш результат \(correctAnswers)/\(questionsAmount)\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                        """
            ) { [weak self] in
                self?.didDismissAlert()
            }
            alertPresenter?.showAlertResults(model: model)
        } else {
            currentQuestionIndex += 1
            
            questionFactory?.requestNextQuestion()
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        hideLoadingIndicator()
    }
    
    private func changeStateButton(isEnabled: Bool){
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        changeStateButton(isEnabled: false)
        showLoadingIndicator()
        
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = true
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == givenAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        changeStateButton(isEnabled: false)
        showLoadingIndicator()
        
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = false
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == givenAnswer)
    }
}
