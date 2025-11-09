#import "@preview/touying:0.6.1": *
#import themes.simple: *
#import "@preview/cetz:0.3.2"
#import "@preview/fletcher:0.5.4" as fletcher: node, edge
#import "@preview/numbly:0.1.0": numbly
#import "@preview/theorion:0.4.1": *
#import "@preview/mitex:0.2.5": *
#import "@preview/equate:0.3.2": *
#import cosmos.clouds: *
#show: show-theorion
#set-inherited-levels(1)

// cetz and fletcher bindings for touying
#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)
#show: equate.with(breakable: true, sub-numbering: false)
#show: simple-theme.with(
  aspect-ratio: "16-9",
  config-common(frozen-counters: (theorem-counter,), show-notes-on-second-screen: right),  // freeze theorem counter for animation
)

#set heading(numbering: numbly("{1}.", default: "1.1"))
#set text(size: 20pt)

#title-slide[
  #heading(level: 1, outlined: false, numbering: none)[Asymptotic Analysis]
  #v(2em)

  Samuka007

  Nov 8
]

// #set-theorion-numbering("1.1")

== Outline <touying:hidden>

#components.adaptive-columns(outline(title: none, indent: 1em))

#let pop-loss-diff = $L lr((hat(theta)), size: #50%) - L lr((theta^*), size: #50%)$

= Theorem

== Asymptotics of empirical risk minimization

#set math.equation(numbering: "(1)")
For the asymptotic analysis of ERM, we would like to prove that excess risk is bounded as shown below:
$ L lr((hat(theta)), size: #50%) - inf_(theta in Theta) L(theta) <= c/n + o(1/n) $ <eq:erm-bound>

// #mitex(`
// L( \hat{\theta} ) - \inf_{\theta \in \Theta} L(\theta) \leq \frac{c}{n} + o\left(\frac{1}{n}\right)
// `)

#speaker-note[
  + This is a speaker note.
  + You won't see it unless you use `config-common(show-notes-on-second-screen: right)`
]

#align(center + horizon)[
  #theorem()[
    Suppose that\ 
    (a) $hat(theta)$ as $n -> infinity$ (i.e. consistency of θˆ), \
    (b) #mi(`\nabla^2 L(\theta^*)`) is full rank, and \
    (c) other appropriate regularity conditions hold.

    #colbreak()

    #set math.equation(numbering: none)
    Then,

    1. $sqrt(n)(hat(theta) - theta^*) = O_P (1)$. <eq:asymp-norm>

    2. $sqrt(n)(hat(theta) - theta^*) ->^d cal(N)(0, (nabla^2L(theta^*))^(-1)"Cov"(nabla cal(l)((x,y), theta^*))(nabla^2L(theta^*))^(-1))$. <eq:asymp-dist>

    3. $n(#pop-loss-diff) = O_P (1)$. <eq:asymp-risk>

    4. $n(#pop-loss-diff) ->^d 1/2 norm(S)^2_2 "where" \
      S ~ cal(N)(0, (nabla^2L(theta^*))^(-1/2)"Cov"(nabla cal(l)((x,y), theta^*))(nabla^2 L(theta^*))^(-1/2))$. <eq:asymp-risk-dist>
    
    5. $lim_(n -> infinity) EE [n(#pop-loss-diff)] = 1/2tr(nabla^2 L(theta^*)^(-1)"Cov"(nabla cal(l)((x,y), theta^*)))$.
  ]
]

== Key ideas of the proof

#slide[
  #set math.equation(numbering: none)
  We will prove the theorem above by applying the following main ideas:

  + Obtain an expression for the excess risk by Taylor expansion of the derivative of the empirical risk $nabla hat(L)(theta)$ around $theta^*$.

  + By _the law of large numbers_, as $n -> infinity$ we have

    $ hat(L)(theta) ->^p L(theta) $
    $ nabla hat(L) (theta) ->^p nabla L(theta) $
    $ nabla^2 hat(L) (theta) ->^p nabla^2 L(theta) $

  + Central limit theorem (CLT).
]

#centered-slide[
  #speaker-note[
    所以一旦我们能够证明 $sqrt(n)(hat(X) - EE(X)) ->^d cal(N)(0, Sigma)$，他就满足定理的第一部分和第二部分。
  ]
  #theorem(title: "Central Limit Theorem")[
    #set math.equation(numbering: none)
    Let $X_1, X_2, dots, X_n$ be i.i.d. random variables, where $hat(X) = 1/n sum_(i=1)^n X_i$ and $Sigma$ is finite. Then, as $n -> infinity$ we have
    $ hat(X) ->^p EE(X) $
    $ sqrt(n)(hat(X) - EE(X)) ->^d cal(N)(0, Sigma) $
    i.e.
    $ sqrt(n)(hat(X) - EE(X)) = O_P (1) $
  ] <thm:clt-iid>
]

= Main proof （一般形式）

== Proof of part 1 & 2
#slide[
  #speaker-note[
    - 让我们从第一部分和第二部分的启发式论证开始。TODO 什么是启发式论证
    - 我们希望将 $hat(theta)$ 与 $theta^*$ 进行比较，因此我们考虑在 $theta^*$ 附近对 $nabla hat(L)(theta)$ 进行泰勒展开。
    - 由于 $hat(theta)$ 是经验风险的极小值点，我们有 $nabla hat(L)(hat(theta)) = 0$。
  ]

  By definition, $hat(theta)$ minimizes the empirical risk, so we have $nabla hat(L)(hat(theta)) = 0$.
  We perform a Taylor expansion of $nabla hat(L)(theta)$ around $theta^*$:
  $ 
  0 = nabla hat(L)(hat(theta)) = nabla hat(L)(theta^*) + nabla^2 hat(L)(theta^*)(hat(theta) - theta^*) + O(norm(hat(theta) - theta^*)^2_2). 
  $
  Rearranging,
  $
  hat(theta) - theta^* = - (nabla^2 hat(L)(theta^*))^(-1) nabla hat(L)(theta^*) + O(norm(hat(theta) - theta^*)^2_2).
  $
  Multiplying both sides by $sqrt(n)$, we get
  $
  sqrt(n)(hat(theta) - theta^*) &= - (nabla^2 hat(L)(theta^*))^(-1) sqrt(n) nabla hat(L)(theta^*) + sqrt(n) O(norm(hat(theta) - theta^*)^2_2) \
    &approx - (nabla^2 L(theta^*))^(-1) sqrt(n) nabla hat(L)(theta^*). #<eq:taylor-expansion-rearranged>
  $

]
#slide[
  === Recall CLT for i.i.d. means
  #theorion-restate(filter: <thm:clt-iid>)
]
#slide[
  #theorem-box(title: "2", outlined: false)[$sqrt(n)(hat(theta) - theta^*) ->^d cal(N)(0, (nabla^2L(theta^*))^(-1)"Cov"(nabla cal(l)((x,y), theta^*))(nabla^2L(theta^*))^(-1)).$]
  Let $X_i = nabla cal(l)((x_i, y_i), theta^*)$ and $hat(X) = nabla hat(L) (theta^*)$, applying @thm:clt-iid,
  $
    sqrt(n) (nabla hat(L)(theta^*) - EE(nabla hat(L)(theta^*))) ->^d cal(N)(0, "Cov"(nabla cal(l)((x,y), theta^*)))
  $
  Since $EE(nabla hat(L)(theta^*)) = nabla L(theta^*) = 0$, we have
  $
    sqrt(n) (nabla hat(L)(theta^*) - nabla L(theta^*)) ->^d cal(N)(0, "Cov"(nabla cal(l)((x,y), theta^*)))
  $
  and thus
  $
    sqrt(n) nabla hat(L)(theta^*) ->^d cal(N)(0, "Cov"(nabla cal(l)((x,y), theta^*))).
  $ <eq:clt-nabla-empirical-risk>
]
#slide[
  #theorem-box(title: "2", outlined: false)[$sqrt(n)(hat(theta) - theta^*) ->^d cal(N)(0, (nabla^2L(theta^*))^(-1)"Cov"(nabla cal(l)((x,y), theta^*))(nabla^2L(theta^*))^(-1)).$]
  #set math.equation(numbering: none)
  Recall @eq:taylor-expansion-rearranged,
  $
    sqrt(n)(hat(theta) - theta^*) approx - (nabla^2 L(theta^*))^(-1) sqrt(n) nabla hat(L)(theta^*).
  $
  From @eq:clt-nabla-empirical-risk,
  $
    sqrt(n) nabla hat(L)(theta^*) ->^d cal(N)(0, "Cov"(nabla cal(l)((x,y), theta^*))).
  $

  #set math.equation(numbering: "(1)")
  By _the law of large numbers_, $nabla^2 hat(L)(theta^*) ->^d nabla^2 L(theta^*)$,
  $ 
    sqrt(n)(hat(theta) - theta^*) 
      &->^d nabla^2 L(theta^*)^(-1) cal(N)(0, "Cov"(nabla cal(l)((x,y), theta^*)))
  $
]

#slide[
  #lemma[
    If $Z ~ cal(N) (0, Sigma)$ and $A$ is a deterministic matrix, then $A Z ~ cal(N)(0, A Sigma A^top)$.
  ] <lem:slutsky-1>
  With an application of Slutsky's theorem // WTF is Slutsky theorem?
  $ 
    sqrt(n)(hat(theta) - theta^*) 
      &->^d nabla^2 L(theta^*)^(-1) cal(N)(0, "Cov"(nabla cal(l)((x,y), theta^*))) #<equate:revoke> \
      &=^d cal(N)(0, (nabla^2L(theta^*))^(-1)"Cov"(nabla cal(l)((x,y), theta^*))(nabla^2L(theta^*))^(-1)) \
    // sqrt(n)(hat(theta) - theta^*) &= O_P (1)
  $
  #theorem-box(title: "1", outlined: false)[$sqrt(n)(hat(theta) - theta^*) &= O_P (1)$]
  Part 1 follows directly from Part 2 by the following fact: If $X_n ->^d X$ for some probability distribution $P$, then $X_n = O_P (1)$.
]

== Proof of part 3 & 4

#slide[
  #speaker-note[
    We now turn to proving Parts 3 and 4.
    - 再次对 $L(hat(theta))$ 在 $theta^*$ 附近进行泰勒展开。
    - 为了使用 Part 1 & 2 中的结论，我们整理等式后乘上 $n$，将 $hat(theta) - theta^*$ 转化为 $sqrt(n)(hat(theta) - theta^*)$ 处理。
    - 在 @eq:trans-def-before 中，根据定义，由于 $L(hat(theta)) - L(theta^*) >= 0$ ，右边处理完是个非负的二次型，那么这个 Hassian 矩阵也是半正定的，所以可以右边将写成范数平方的形式，即 @eq:trans-def-after。
  ]
  #theorem-box(title: "4", outlined: false)[$
      n(L(hat(theta)) - L(theta^*)) ->^d 1/2 norm(S)^2_2 "where" \
      S ~ cal(N)(0, (nabla^2L(theta^*))^(-1/2)"Cov"(nabla cal(l)((x,y), theta^*))(nabla^2 L(theta^*))^(-1/2))
  $]
  Using a Taylor expansion of $L$ with respect to $theta$ around $theta^*$, we find
  $
    L(hat(theta)) = L(theta^*) + 1/2 (hat(theta) - theta^*)^top nabla^2 L(theta^*) (hat(theta) - theta^*) + o(norm(hat(theta) - theta^*)^2_2).
  $
]

#slide[
  #theorem-box(title: "4", outlined: false)[$sqrt(n)(hat(theta) - theta^*) ->^d cal(N)(0, (nabla^2L(theta^*))^(-1)"Cov"(nabla cal(l)((x,y), theta^*))(nabla^2L(theta^*))^(-1)).$]
  For minimizer $theta^*$, we have $nabla L(theta^*) = 0$. Rearranging and multiplying both sides by $n$, we get
  $
    n(#pop-loss-diff) 
      &= n/2 chevron.l hat(theta) - theta^*, nabla^2 L(theta^*) (hat(theta) - theta^*) chevron.r + o(norm(hat(theta) - theta^*)^2_2) #<eq:taylor-expansion-risk> \
      &approx 1/2 chevron.l underbrace(sqrt(n)(hat(theta) - theta^*), v), underbrace(nabla^2 L(theta^*) sqrt(n)(hat(theta) - theta^*), A v) chevron.r #<eq:trans-def-before> \
      &= 1/2 norm(nabla^2 L(theta^*)^(1/2) sqrt(n)(hat(theta) - theta^*))^2_2, #<eq:trans-def-after> \
  $
]

#slide[
  #speaker-note[
    By Part 2, we know the asymptotic distribution of $sqrt(n)(hat(theta) - theta^*)$ is Gaussian.
  ]
  Let 
  $ 
    S = nabla^2 L(theta^*)^(1/2) underbrace(sqrt(n)(hat(theta) - theta^*), "Gaussian" v),
  $
  i.e. the random vector inside the norm. As $n -> oo$, we have $n(#pop-loss-diff) ->^d 1/2 norm(S)^2_2$, where
  $
    S &~ nabla^2 L(theta^*)^(1/2) cal(N)(0, nabla^2 L(theta^*)^(-1)"Cov"(nabla cal(l)((x,y), theta^*))nabla^2L(theta^*)^(-1)) \
      &= cal(N)(0, nabla^2L(theta^*)^(-1/2)"Cov"(nabla cal(l)((x,y), theta^*))nabla^2 L(theta^*)^(-1/2)).
  $
  #theorion-restate(filter: <lem:slutsky-1>)
]

== Proof of part 5

#slide[
  #lemma[
    If $Z ~ cal(N)(0, Sigma^(-1))$, and $Z in RR^p$, then $Z^top Sigma Z ~ chi^2(p)$.
  ] <lem:chi-squared>

]

