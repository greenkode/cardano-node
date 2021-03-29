module Test.Golden.Diff (diffVsFile) where

import           Cardano.Prelude
import           Prelude (String)
import qualified Prelude

import           Hedgehog (MonadTest)
import           Hedgehog.Extras.Test.Base (failMessage)
import           System.Process (readProcessWithExitCode)

diffVsFile
  :: (MonadIO m, MonadTest m)
  => String   -- ^ actual content
  -> FilePath -- ^ reference file
  -> m ()
diffVsFile actualContent referenceFile = do
  (diffExitCode, diffStdout, diffStderr) <-
    liftIO $
      readProcessWithExitCode
        "diff"
        ["-u", "--", "-", referenceFile]
        actualContent
  case diffExitCode of
    ExitSuccess -> pure ()
    ExitFailure _ ->
      failMessage callStack $
      Prelude.unlines
        [ "Process exited with non-zero exit-code"
        , "━━━━ stdout ━━━━"
        , diffStdout
        , "━━━━ stderr ━━━━"
        , diffStderr
        ]
