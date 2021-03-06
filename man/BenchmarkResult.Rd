% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BenchmarkResult.R
\name{BenchmarkResult}
\alias{BenchmarkResult}
\title{Container for Benchmarking Results}
\description{
This is the result container object returned by \code{\link[=benchmark]{benchmark()}}.
A \link{BenchmarkResult} consists of the data row-binded data of multiple
\link{ResampleResult}s, which can easily be re-constructed.

\link{BenchmarkResult}s can be visualized via \CRANpkg{mlr3viz}'s \code{autoplot()} function.

For statistical analysis of benchmark results and more advanced plots, see \CRANpkg{mlr3benchmark}.
}
\note{
All stored objects are accessed by reference.
Do not modify any extracted object without cloning it first.
}
\section{S3 Methods}{

\itemize{
\item \code{as.data.table(rr, ..., reassemble_learners = TRUE, convert_predictions = TRUE, predict_sets = "test")}\cr
\link{BenchmarkResult} -> \code{\link[data.table:data.table]{data.table::data.table()}}\cr
Returns a tabular view of the internal data.
\item \code{c(...)}\cr
(\link{BenchmarkResult}, ...) -> \link{BenchmarkResult}\cr
Combines multiple objects convertible to \link{BenchmarkResult} into a new \link{BenchmarkResult}.
}
}

\examples{
set.seed(123)
learners = list(
  lrn("classif.featureless", predict_type = "prob"),
  lrn("classif.rpart", predict_type = "prob")
)

design = benchmark_grid(
  tasks = list(tsk("sonar"), tsk("spam")),
  learners = learners,
  resamplings = rsmp("cv", folds = 3)
)
print(design)

bmr = benchmark(design)
print(bmr)

bmr$tasks
bmr$learners

# first 5 resampling iterations
head(as.data.table(bmr, measures = c("classif.acc", "classif.auc")), 5)

# aggregate results
bmr$aggregate()

# aggregate results with hyperparameters as separate columns
mlr3misc::unnest(bmr$aggregate(params = TRUE), "params")

# extract resample result for classif.rpart
rr = bmr$aggregate()[learner_id == "classif.rpart", resample_result][[1]]
print(rr)

# access the confusion matrix of the first resampling iteration
rr$predictions()[[1]]$confusion

# reduce to subset with task id "sonar"
bmr$filter(task_ids = "sonar")
print(bmr)
}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{data}}{(\code{ResultData})\cr
Internal data storage object of type \code{ResultData}.
We discourage users to directly work with this field.
Use \code{as.table.table(BenchmarkResult)} instead.}
}
\if{html}{\out{</div>}}
}
\section{Active bindings}{
\if{html}{\out{<div class="r6-active-bindings">}}
\describe{
\item{\code{task_type}}{(\code{character(1)})\cr
Task type of objects in the \code{BenchmarkResult}.
All stored objects (\link{Task}, \link{Learner}, \link{Prediction}) in a single \code{BenchmarkResult} are
required to have the same task type, e.g., \code{"classif"} or \code{"regr"}.
This is \code{NA} for empty \link{BenchmarkResult}s.}

\item{\code{tasks}}{(\code{\link[data.table:data.table]{data.table::data.table()}})\cr
Table of included \link{Task}s with three columns:
\itemize{
\item \code{"task_hash"} (\code{character(1)}),
\item \code{"task_id"} (\code{character(1)}), and
\item \code{"task"} (\link{Task}).
}}

\item{\code{learners}}{(\code{\link[data.table:data.table]{data.table::data.table()}})\cr
Table of included \link{Learner}s with three columns:
\itemize{
\item \code{"learner_hash"} (\code{character(1)}),
\item \code{"learner_id"} (\code{character(1)}), and
\item \code{"learner"} (\link{Learner}).
}

Note that it is not feasible to access learned models via this field, as the training task would be ambiguous.
For this reason the returned learner are reseted before they are returned.
Instead, select a row from the table returned by \verb{$score()}.}

\item{\code{resamplings}}{(\code{\link[data.table:data.table]{data.table::data.table()}})\cr
Table of included \link{Resampling}s with three columns:
\itemize{
\item \code{"resampling_hash"} (\code{character(1)}),
\item \code{"resampling_id"} (\code{character(1)}), and
\item \code{"resampling"} (\link{Resampling}).
}}

\item{\code{resample_results}}{(\code{\link[data.table:data.table]{data.table::data.table()}})\cr
Returns a table with three columns:
\itemize{
\item \code{uhash} (\code{character()}).
\item \code{resample_result} (\link{ResampleResult}).
}}

\item{\code{n_resample_results}}{(\code{integer(1)})\cr
Returns the total number of stored \link{ResampleResult}s.}

\item{\code{uhashes}}{(\code{character()})\cr
Set of (unique) hashes of all included \link{ResampleResult}s.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{BenchmarkResult$new()}}
\item \href{#method-help}{\code{BenchmarkResult$help()}}
\item \href{#method-format}{\code{BenchmarkResult$format()}}
\item \href{#method-print}{\code{BenchmarkResult$print()}}
\item \href{#method-combine}{\code{BenchmarkResult$combine()}}
\item \href{#method-score}{\code{BenchmarkResult$score()}}
\item \href{#method-aggregate}{\code{BenchmarkResult$aggregate()}}
\item \href{#method-filter}{\code{BenchmarkResult$filter()}}
\item \href{#method-resample_result}{\code{BenchmarkResult$resample_result()}}
\item \href{#method-clone}{\code{BenchmarkResult$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
Creates a new instance of this \link[R6:R6Class]{R6} class.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{BenchmarkResult$new(data = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{data}}{(\code{ResultData})\cr
An object of type \code{ResultData}, either extracted from another \link{ResampleResult}, another
\link{BenchmarkResult}, or manually constructed with \code{\link[=as_result_data]{as_result_data()}}.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-help"></a>}}
\if{latex}{\out{\hypertarget{method-help}{}}}
\subsection{Method \code{help()}}{
Opens the help page for this object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{BenchmarkResult$help()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-format"></a>}}
\if{latex}{\out{\hypertarget{method-format}{}}}
\subsection{Method \code{format()}}{
Helper for print outputs.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{BenchmarkResult$format()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-print"></a>}}
\if{latex}{\out{\hypertarget{method-print}{}}}
\subsection{Method \code{print()}}{
Printer.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{BenchmarkResult$print()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-combine"></a>}}
\if{latex}{\out{\hypertarget{method-combine}{}}}
\subsection{Method \code{combine()}}{
Fuses a second \link{BenchmarkResult} into itself, mutating the \link{BenchmarkResult} in-place.
If the second \link{BenchmarkResult} \code{bmr} is \code{NULL}, simply returns \code{self}.
Note that you can alternatively use the combine function \code{\link[=c]{c()}} which calls this method internally.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{BenchmarkResult$combine(bmr)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{bmr}}{(\link{BenchmarkResult})\cr
A second \link{BenchmarkResult} object.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
Returns the object itself, but modified \strong{by reference}.
You need to explicitly \verb{$clone()} the object beforehand if you want to keep
the object in its previous state.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-score"></a>}}
\if{latex}{\out{\hypertarget{method-score}{}}}
\subsection{Method \code{score()}}{
Returns a table with one row for each resampling iteration, including
all involved objects: \link{Task}, \link{Learner}, \link{Resampling}, iteration number
(\code{integer(1)}), and \link{Prediction}. If \code{ids} is set to \code{TRUE}, character
column of extracted ids are added to the table for convenient
filtering: \code{"task_id"}, \code{"learner_id"}, and \code{"resampling_id"}.

Additionally calculates the provided performance measures and binds the
performance scores as extra columns. These columns are named using the id of
the respective \link{Measure}.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{BenchmarkResult$score(
  measures = NULL,
  ids = TRUE,
  conditions = FALSE,
  predict_sets = "test"
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{measures}}{(\link{Measure} | list of \link{Measure})\cr
Measure(s) to calculate.}

\item{\code{ids}}{(\code{logical(1)})\cr
Adds object ids (\code{"task_id"}, \code{"learner_id"}, \code{"resampling_id"}) as
extra character columns to the returned table.}

\item{\code{conditions}}{(\code{logical(1)})\cr
Adds condition messages (\code{"warnings"}, \code{"errors"}) as extra
list columns of character vectors to the returned table}

\item{\code{predict_sets}}{(\code{character()})\cr
Prediction sets to operate on, used in \code{aggregate()} to extract the matching \code{predict_sets} from the \link{ResampleResult}.
Multiple predict sets are calculated by the respective \link{Learner} during \code{\link[=resample]{resample()}}/\code{\link[=benchmark]{benchmark()}}.
Must be a non-empty subset of \verb{\{"train", "test", "validation"\}}.
If multiple sets are provided, these are first combined to a single prediction object.
Default is \code{"test"}.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{\link[data.table:data.table]{data.table::data.table()}}.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-aggregate"></a>}}
\if{latex}{\out{\hypertarget{method-aggregate}{}}}
\subsection{Method \code{aggregate()}}{
Returns a result table where resampling iterations are combined into
\link{ResampleResult}s. A column with the aggregated performance score is
added for each \link{Measure}, named with the id of the respective measure.

For convenience, different flags can be set to extract more
information from the returned \link{ResampleResult}:
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{BenchmarkResult$aggregate(
  measures = NULL,
  ids = TRUE,
  uhashes = FALSE,
  params = FALSE,
  conditions = FALSE
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{measures}}{(\link{Measure} | list of \link{Measure})\cr
Measure(s) to calculate.}

\item{\code{ids}}{(\code{logical(1)})\cr
Adds object ids (\code{"task_id"}, \code{"learner_id"}, \code{"resampling_id"}) as
extra character columns for convenient subsetting.}

\item{\code{uhashes}}{(\code{logical(1)})\cr
Adds the uhash values of the \link{ResampleResult} as extra character
column \code{"uhash"}.}

\item{\code{params}}{(\code{logical(1)})\cr
Adds the hyperparameter values as extra list column \code{"params"}. You
can unnest them with \code{\link[mlr3misc:unnest]{mlr3misc::unnest()}}.}

\item{\code{conditions}}{(\code{logical(1)})\cr
Adds the number of resampling iterations with at least one warning as
extra integer column \code{"warnings"}, and the number of resampling
iterations with errors as extra integer column \code{"errors"}.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{\link[data.table:data.table]{data.table::data.table()}}.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-filter"></a>}}
\if{latex}{\out{\hypertarget{method-filter}{}}}
\subsection{Method \code{filter()}}{
Subsets the benchmark result. If \code{task_ids} is not \code{NULL}, keeps all
tasks with provided task ids and discards all others tasks.
Same procedure for \code{learner_ids} and \code{resampling_ids}.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{BenchmarkResult$filter(
  task_ids = NULL,
  task_hashes = NULL,
  learner_ids = NULL,
  learner_hashes = NULL,
  resampling_ids = NULL,
  resampling_hashes = NULL
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{task_ids}}{(\code{character()})\cr
Ids of \link{Task}s to keep.}

\item{\code{task_hashes}}{(\code{character()})\cr
Hashes of \link{Task}s to keep.}

\item{\code{learner_ids}}{(\code{character()})\cr
Ids of \link{Learner}s to keep.}

\item{\code{learner_hashes}}{(\code{character()})\cr
Hashes of \link{Learner}s to keep.}

\item{\code{resampling_ids}}{(\code{character()})\cr
Ids of \link{Resampling}s to keep.}

\item{\code{resampling_hashes}}{(\code{character()})\cr
Hashes of \link{Resampling}s to keep.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
Returns the object itself, but modified \strong{by reference}.
You need to explicitly \verb{$clone()} the object beforehand if you want to keeps
the object in its previous state.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-resample_result"></a>}}
\if{latex}{\out{\hypertarget{method-resample_result}{}}}
\subsection{Method \code{resample_result()}}{
Retrieve the i-th \link{ResampleResult}, by position or by unique hash \code{uhash}.
\code{i} and \code{uhash} are mutually exclusive.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{BenchmarkResult$resample_result(i = NULL, uhash = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{i}}{(\code{integer(1)})\cr
The iteration value to filter for.}

\item{\code{uhash}}{(\code{logical(1)})\cr
The \code{ushash} value to filter for.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\link{ResampleResult}.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{BenchmarkResult$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
