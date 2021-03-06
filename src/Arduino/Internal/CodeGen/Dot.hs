-- Copyright (c) 2014 Contributors as noted in the AUTHORS file
--
-- This file is part of frp-arduino.
--
-- frp-arduino is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- frp-arduino is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with frp-arduino.  If not, see <http://www.gnu.org/licenses/>.

module Arduino.Internal.CodeGen.Dot
    ( streamsToDot
    ) where

import Arduino.Internal.CodeGen.BlockDoc
import Arduino.Internal.DAG
import Control.Monad

streamsToDot :: Streams -> String
streamsToDot = runGen . genStreamsDotFile

genStreamsDotFile :: Streams -> Gen ()
genStreamsDotFile streams = do
    header "// This file is automatically generated."
    header ""
    block "digraph {" $ do
        mapM genStreamDotCode (streamsInTree streams)
    line "}"

genStreamDotCode :: Stream -> Gen ()
genStreamDotCode stream = do
    line $ concat
        [ name stream
        , "["
            , "shape=\"rectangle\","
            , "style=\"rounded\","
            , "label=<"
                , "<b>"
                    , name stream
                , "</b>"
                , "<br/>"
                , prettyString (body stream)
            , ">"
        , "];"
        ]
    forM_ (outputs stream) $ \(_, outputName) -> do
        line $ concat
            [ name stream
            , " -> "
            , outputName
            , ";"
            ]

prettyString :: Show a => a -> String
prettyString a = concatMap replace $ show a ++ leftAllignedNewline
    where
        replace '(' = "(" ++ leftAllignedNewline
        replace '[' = "[" ++ leftAllignedNewline
        replace ',' = "," ++ leftAllignedNewline
        replace x   = [x]
        leftAllignedNewline = "<br align=\"left\"/>"
