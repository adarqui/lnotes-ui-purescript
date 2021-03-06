module LN.State.Types (
  State,
  DriverCh,
  initialState
) where



import LN.Router.Class.Routes       (Routes)
import LN.State.Internal.Types      (InternalState)
import Control.Monad.Aff.AVar       (AVar())
import Data.Map                     as M
import Data.Maybe                   (Maybe(..))
import Prelude                      (Unit)

-- import LN.Router.Types              (Routes(..))
import LN.Input.Types               (Input)
import LN.Router.Class.Routes       (Routes(..))
import LN.State.ArrayString         (defaultArrayStringState)
import LN.State.Loading (defaultLoadingMap)
import LN.State.PageInfo (defaultPageInfo, defaultPageInfo_BucketRounds, defaultPageInfo_Buckets, defaultPageInfo_Leurons, defaultPageInfo_Resources, defaultPageInfo_Users)



-- type State    = InternalState Routes DriverCh -- TODO FIXME CYCLIC
type State = InternalState Routes



type DriverCh = AVar (Input Unit)



initialState :: AVar (Input Unit) -> State
initialState ch =
  { currentPage:                  Home
  , me:                           Nothing
  , meId:                         0
  , errors:                       []
  , users:                        M.empty
  , usersMap:                     M.empty
  , leurons:                      M.empty
  , resources:                    M.empty
  , buckets:                      M.empty
  , bucketResources:              M.empty
  , bucketLeurons:                M.empty
  , bucketRounds:                 M.empty
  , currentUser:                  Nothing
  , currentResource:              Nothing
  , currentResourceRequest:       Nothing
  , currentResourceRequestSt:     Nothing
  , currentLeuron:                Nothing
  , currentLeuronRequest:         Nothing
  , currentLeuronRequestSt:       Nothing
  , currentBucket:                Nothing
  , currentBucketRequest:         Nothing
  , currentBucketRequestSt:       Nothing
  , currentBucketRound:                Nothing
  , currentBucketRoundRequest:         Nothing
  , currentBucketRoundRequestSt:       Nothing
  , currentBucketRoundLeuronsCount:    0
  , currentPageInfo:              defaultPageInfo
  , usersPageInfo:                defaultPageInfo_Users
  -- need dsc by modifiedAt !!!!!!!! TODO FIXME
  , resourcesPageInfo:            defaultPageInfo_Resources
  , leuronsPageInfo:              defaultPageInfo_Leurons
  , bucketsPageInfo:              defaultPageInfo_Buckets
  , bucketRoundsPageInfo:         defaultPageInfo_BucketRounds
  , arrayStringSt:                defaultArrayStringState
--  , driverCh:                     ch
  , loading:                      defaultLoadingMap
  }
