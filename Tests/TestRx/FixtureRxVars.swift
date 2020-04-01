import MockoloFramework


let rx = """
/// \(String.mockAnnotation)(rx: attachedRouter = BehaviorSubject)
protocol TaskRouting: BaseRouting {
    var attachedRouter: Observable<Bool> { get }
    func routeToFoo() -> Observable<()>
}

"""

let rxMock = """



class TaskRoutingMock: TaskRouting {
    init() { }
    init(attachedRouter: Observable<Bool> = BehaviorSubject<Bool>(value: false)) {
        self.attachedRouter = attachedRouter
    }
    var attachedRouterSubjectSetCallCount = 0
    var _attachedRouter: Observable<Bool>? { didSet { attachedRouterSubjectSetCallCount += 1 } }
    var attachedRouterSubject = BehaviorSubject<Bool>(value: false) { didSet { attachedRouterSubjectSetCallCount += 1 } }
    var attachedRouter: Observable<Bool> {
        get { return _attachedRouter ?? attachedRouterSubject }
        set { if let val = newValue as? BehaviorSubject<Bool> { attachedRouterSubject = val } else { _attachedRouter = newValue } }
    }
    var routeToFooCallCount = 0
    var routeToFooHandler: (() -> (Observable<()>))?
    func routeToFoo() -> Observable<()> {
        routeToFooCallCount += 1
        if let routeToFooHandler = routeToFooHandler {
            return routeToFooHandler()
        }
        return Observable<()>.empty()
    }
}

"""


let rxVarSubjects = """
/// \(String.mockAnnotation)(rx: nameStream = BehaviorSubject; integerStream = ReplaySubject)
protocol RxVar {
    var isEnabled: Observable<Bool> { get }
    var nameStream: Observable<[EMobilitySearchVehicle]> { get }
    var integerStream: Observable<Int> { get }
}
"""

let rxVarSubjectsMock = """

class RxVarMock: RxVar {
    init() { }
    init(isEnabled: Observable<Bool> = PublishSubject<Bool>(), nameStream: Observable<[EMobilitySearchVehicle]> = BehaviorSubject<[EMobilitySearchVehicle]>(value: [EMobilitySearchVehicle]()), integerStream: Observable<Int> = ReplaySubject<Int>.create(bufferSize: 1)) {
        self.isEnabled = isEnabled
        self.nameStream = nameStream
        self.integerStream = integerStream
    }
    var isEnabledSubjectSetCallCount = 0
    var _isEnabled: Observable<Bool>? { didSet { isEnabledSubjectSetCallCount += 1 } }
    var isEnabledSubject = PublishSubject<Bool>() { didSet { isEnabledSubjectSetCallCount += 1 } }
    var isEnabled: Observable<Bool> {
        get { return _isEnabled ?? isEnabledSubject }
        set { if let val = newValue as? PublishSubject<Bool> { isEnabledSubject = val } else { _isEnabled = newValue } }
    }
    var nameStreamSubjectSetCallCount = 0
    var _nameStream: Observable<[EMobilitySearchVehicle]>? { didSet { nameStreamSubjectSetCallCount += 1 } }
    var nameStreamSubject = BehaviorSubject<[EMobilitySearchVehicle]>(value: [EMobilitySearchVehicle]()) { didSet { nameStreamSubjectSetCallCount += 1 } }
    var nameStream: Observable<[EMobilitySearchVehicle]> {
        get { return _nameStream ?? nameStreamSubject }
        set { if let val = newValue as? BehaviorSubject<[EMobilitySearchVehicle]> { nameStreamSubject = val } else { _nameStream = newValue } }
    }
    var integerStreamSubjectSetCallCount = 0
    var _integerStream: Observable<Int>? { didSet { integerStreamSubjectSetCallCount += 1 } }
    var integerStreamSubject = ReplaySubject<Int>.create(bufferSize: 1) { didSet { integerStreamSubjectSetCallCount += 1 } }
    var integerStream: Observable<Int> {
        get { return _integerStream ?? integerStreamSubject }
        set { if let val = newValue as? ReplaySubject<Int> { integerStreamSubject = val } else { _integerStream = newValue } }
    }
}


"""

let rxVarInherited =
"""
/// \(String.mockAnnotation)(rx: all = BehaviorSubject)
public protocol X {
    var myKey: Observable<SomeKey?> { get }
}

/// \(String.mockAnnotation)
public protocol Y: X {
    func update(with key: SomeKey)
}
"""

let rxVarInheritedMock = """


public class XMock: X {
    public init() { }
    public init(myKey: Observable<SomeKey?> = BehaviorSubject<SomeKey?>(value: nil)) {
        self.myKey = myKey
    }
    public var myKeySubjectSetCallCount = 0
    var _myKey: Observable<SomeKey?>? { didSet { myKeySubjectSetCallCount += 1 } }
    public var myKeySubject = BehaviorSubject<SomeKey?>(value: nil) { didSet { myKeySubjectSetCallCount += 1 } }
    public var myKey: Observable<SomeKey?> {
        get { return _myKey ?? myKeySubject }
        set { if let val = newValue as? BehaviorSubject<SomeKey?> { myKeySubject = val } else { _myKey = newValue } }
    }
}

public class YMock: Y {
    public init() { }
    public init(myKey: Observable<SomeKey?> = PublishSubject<SomeKey?>()) {
        self.myKey = myKey
    }
    public var myKeySubjectSetCallCount = 0
    var _myKey: Observable<SomeKey?>? { didSet { myKeySubjectSetCallCount += 1 } }
    public var myKeySubject = BehaviorSubject<SomeKey?>(value: nil) { didSet { myKeySubjectSetCallCount += 1 } }
    public var myKey: Observable<SomeKey?> {
        get { return _myKey ?? myKeySubject }
        set { if let val = newValue as? BehaviorSubject<SomeKey?> { myKeySubject = val } else { _myKey = newValue } }
    }
    public var updateCallCount = 0
    public var updateHandler: ((SomeKey) -> ())?
    public func update(with key: SomeKey)  {
        updateCallCount += 1
        if let updateHandler = updateHandler {
            updateHandler(key)
        }

    }
}


"""



let rxMultiParents =
"""
/// \(String.mockAnnotation)
public protocol TasksStream: BaseTasksStream {
    func update(tasks: Tasks)
}

public protocol BaseTasksStream: BaseTaskScopeListStream, WorkTaskScopeListStream, StateStream, OnlineStream, CompletionTasksStream, WorkStateStream {
    var tasks: Observable<Tasks> { get }
}

/// \(String.mockAnnotation)(rx: all = ReplaySubject)
public protocol BaseTaskScopeListStream: AnyObject {
    var taskScopes: Observable<[TaskScope]> { get }
}

/// \(String.mockAnnotation)(rx: all = ReplaySubject)
public protocol WorkTaskScopeListStream: AnyObject {
    var workTaskScopes: Observable<[TaskScope]> { get }
}

/// \(String.mockAnnotation)
public protocol OnlineStream: AnyObject {
    var online: Observable<Bool> { get }
}
/// \(String.mockAnnotation)
public protocol StateStream: AnyObject {
    var state: Observable<State> { get }
}

/// \(String.mockAnnotation)(rx: all = BehaviorSubject)
public protocol WorkStateStream: AnyObject {
    var isOnJob: Observable<Bool> { get }
}

/// \(String.mockAnnotation)(rx: all = BehaviorSubject)
public protocol CompletionTasksStream: AnyObject {
    var completionTasks: Observable<[CompletionTask]> { get }
}
"""


let rxMultiParentsMock = """

public class TasksStreamMock: TasksStream {
    public init() { }
    public init(tasks: Observable<Tasks> = PublishSubject<Tasks>(), taskScopes: Observable<[TaskScope]> = PublishSubject<[TaskScope]>(), workTaskScopes: Observable<[TaskScope]> = PublishSubject<[TaskScope]>(), online: Observable<Bool> = PublishSubject<Bool>(), state: Observable<State> = PublishSubject<State>(), isOnJob: Observable<Bool> = PublishSubject<Bool>(), completionTasks: Observable<[CompletionTask]> = PublishSubject<[CompletionTask]>()) {
        self.tasks = tasks
        self.taskScopes = taskScopes
        self.workTaskScopes = workTaskScopes
        self.online = online
        self.state = state
        self.isOnJob = isOnJob
        self.completionTasks = completionTasks
    }
    public var updateCallCount = 0
    public var updateHandler: ((Tasks) -> ())?
    public func update(tasks: Tasks)  {
        updateCallCount += 1
        if let updateHandler = updateHandler {
            updateHandler(tasks)
        }

    }
    public var tasksSubjectSetCallCount: Int { return self._tasks.callCount }
    public var tasksSubject: PublishSubject<Tasks> { return self._tasks.publishSubject }
    public var tasksReplaySubject: ReplaySubject<Tasks> { return self._tasks.replaySubject }
    public var tasksBehaviorSubject: BehaviorSubject<Tasks> { return self._tasks.behaviorSubject }
    @MockObservable(unwrapped: Observable<Tasks>.empty()) public var tasks: Observable<Tasks>
    public var taskScopesSubjectSetCallCount = 0
    var _taskScopes: Observable<[TaskScope]>? { didSet { taskScopesSubjectSetCallCount += 1 } }
    public var taskScopesSubject = ReplaySubject<[TaskScope]>.create(bufferSize: 1) { didSet { taskScopesSubjectSetCallCount += 1 } }
    public var taskScopes: Observable<[TaskScope]> {
        get { return _taskScopes ?? taskScopesSubject }
        set { if let val = newValue as? ReplaySubject<[TaskScope]> { taskScopesSubject = val } else { _taskScopes = newValue } }
    }
    public var workTaskScopesSubjectSetCallCount = 0
    var _workTaskScopes: Observable<[TaskScope]>? { didSet { workTaskScopesSubjectSetCallCount += 1 } }
    public var workTaskScopesSubject = ReplaySubject<[TaskScope]>.create(bufferSize: 1) { didSet { workTaskScopesSubjectSetCallCount += 1 } }
    public var workTaskScopes: Observable<[TaskScope]> {
        get { return _workTaskScopes ?? workTaskScopesSubject }
        set { if let val = newValue as? ReplaySubject<[TaskScope]> { workTaskScopesSubject = val } else { _workTaskScopes = newValue } }
    }
    public var onlineSubjectSetCallCount: Int { return self._online.callCount }
    public var onlineSubject: PublishSubject<Bool> { return self._online.publishSubject }
    public var onlineReplaySubject: ReplaySubject<Bool> { return self._online.replaySubject }
    public var onlineBehaviorSubject: BehaviorSubject<Bool> { return self._online.behaviorSubject }
    @MockObservable(unwrapped: Observable<Bool>.empty()) public var online: Observable<Bool>
    public var stateSubjectSetCallCount: Int { return self._state.callCount }
    public var stateSubject: PublishSubject<State> { return self._state.publishSubject }
    public var stateReplaySubject: ReplaySubject<State> { return self._state.replaySubject }
    public var stateBehaviorSubject: BehaviorSubject<State> { return self._state.behaviorSubject }
    @MockObservable(unwrapped: Observable<State>.empty()) public var state: Observable<State>
    public var isOnJobSubjectSetCallCount = 0
    var _isOnJob: Observable<Bool>? { didSet { isOnJobSubjectSetCallCount += 1 } }
    public var isOnJobSubject = BehaviorSubject<Bool>(value: false) { didSet { isOnJobSubjectSetCallCount += 1 } }
    public var isOnJob: Observable<Bool> {
        get { return _isOnJob ?? isOnJobSubject }
        set { if let val = newValue as? BehaviorSubject<Bool> { isOnJobSubject = val } else { _isOnJob = newValue } }
    }
    public var completionTasksSubjectSetCallCount = 0
    var _completionTasks: Observable<[CompletionTask]>? { didSet { completionTasksSubjectSetCallCount += 1 } }
    public var completionTasksSubject = BehaviorSubject<[CompletionTask]>(value: [CompletionTask]()) { didSet { completionTasksSubjectSetCallCount += 1 } }
    public var completionTasks: Observable<[CompletionTask]> {
        get { return _completionTasks ?? completionTasksSubject }
        set { if let val = newValue as? BehaviorSubject<[CompletionTask]> { completionTasksSubject = val } else { _completionTasks = newValue } }
    }
}

public class BaseTaskScopeListStreamMock: BaseTaskScopeListStream {
    public init() { }
    public init(taskScopes: Observable<[TaskScope]> = ReplaySubject<[TaskScope]>.create(bufferSize: 1)) {
        self.taskScopes = taskScopes
    }
    public var taskScopesSubjectSetCallCount = 0
    var _taskScopes: Observable<[TaskScope]>? { didSet { taskScopesSubjectSetCallCount += 1 } }
    public var taskScopesSubject = ReplaySubject<[TaskScope]>.create(bufferSize: 1) { didSet { taskScopesSubjectSetCallCount += 1 } }
    public var taskScopes: Observable<[TaskScope]> {
        get { return _taskScopes ?? taskScopesSubject }
        set { if let val = newValue as? ReplaySubject<[TaskScope]> { taskScopesSubject = val } else { _taskScopes = newValue } }
    }
}

public class WorkTaskScopeListStreamMock: WorkTaskScopeListStream {
    public init() { }
    public init(workTaskScopes: Observable<[TaskScope]> = ReplaySubject<[TaskScope]>.create(bufferSize: 1)) {
        self.workTaskScopes = workTaskScopes
    }
    public var workTaskScopesSubjectSetCallCount = 0
    var _workTaskScopes: Observable<[TaskScope]>? { didSet { workTaskScopesSubjectSetCallCount += 1 } }
    public var workTaskScopesSubject = ReplaySubject<[TaskScope]>.create(bufferSize: 1) { didSet { workTaskScopesSubjectSetCallCount += 1 } }
    public var workTaskScopes: Observable<[TaskScope]> {
        get { return _workTaskScopes ?? workTaskScopesSubject }
        set { if let val = newValue as? ReplaySubject<[TaskScope]> { workTaskScopesSubject = val } else { _workTaskScopes = newValue } }
    }
}

public class OnlineStreamMock: OnlineStream {
    public init() { }
    public init(online: Observable<Bool> = PublishSubject<Bool>()) {
        self.online = online
    }
    public var onlineSubjectSetCallCount: Int { return self._online.callCount }
    public var onlineSubject: PublishSubject<Bool> { return self._online.publishSubject }
    public var onlineReplaySubject: ReplaySubject<Bool> { return self._online.replaySubject }
    public var onlineBehaviorSubject: BehaviorSubject<Bool> { return self._online.behaviorSubject }
    @MockObservable(unwrapped: Observable<Bool>.empty()) public var online: Observable<Bool>
}

public class StateStreamMock: StateStream {
    public init() { }
    public init(state: Observable<State> = PublishSubject<State>()) {
        self.state = state
    }
    public var stateSubjectSetCallCount: Int { return self._state.callCount }
    public var stateSubject: PublishSubject<State> { return self._state.publishSubject }
    public var stateReplaySubject: ReplaySubject<State> { return self._state.replaySubject }
    public var stateBehaviorSubject: BehaviorSubject<State> { return self._state.behaviorSubject }
    @MockObservable(unwrapped: Observable<State>.empty()) public var state: Observable<State>
}

public class WorkStateStreamMock: WorkStateStream {
    public init() { }
    public init(isOnJob: Observable<Bool> = BehaviorSubject<Bool>(value: false)) {
        self.isOnJob = isOnJob
    }
    public var isOnJobSubjectSetCallCount = 0
    var _isOnJob: Observable<Bool>? { didSet { isOnJobSubjectSetCallCount += 1 } }
    public var isOnJobSubject = BehaviorSubject<Bool>(value: false) { didSet { isOnJobSubjectSetCallCount += 1 } }
    public var isOnJob: Observable<Bool> {
        get { return _isOnJob ?? isOnJobSubject }
        set { if let val = newValue as? BehaviorSubject<Bool> { isOnJobSubject = val } else { _isOnJob = newValue } }
    }
}

public class CompletionTasksStreamMock: CompletionTasksStream {
    public init() { }
    public init(completionTasks: Observable<[CompletionTask]> = BehaviorSubject<[CompletionTask]>(value: [CompletionTask]())) {
        self.completionTasks = completionTasks
    }
    public var completionTasksSubjectSetCallCount = 0
    var _completionTasks: Observable<[CompletionTask]>? { didSet { completionTasksSubjectSetCallCount += 1 } }
    public var completionTasksSubject = BehaviorSubject<[CompletionTask]>(value: [CompletionTask]()) { didSet { completionTasksSubjectSetCallCount += 1 } }
    public var completionTasks: Observable<[CompletionTask]> {
        get { return _completionTasks ?? completionTasksSubject }
        set { if let val = newValue as? BehaviorSubject<[CompletionTask]> { completionTasksSubject = val } else { _completionTasks = newValue } }
    }
}

"""

