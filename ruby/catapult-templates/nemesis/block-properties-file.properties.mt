[nemesis]

networkIdentifier = {{network_identifier}}
nemesisGenerationHash = {{nemesis_generation_hash}}
nemesisSignerPrivateKey = {{nemesis_signer_private_key}}

[cpp]

cppFileHeader =

[output]

cppFile =
binDirectory = ../seed/mijin-test

[namespaces]

jz = true
jz.gas = true
jz.jzj = true

[namespace>jz]

duration = 0

[mosaics]

jz:gas = true
jz:jzj = true

[mosaic>jz:gas]

divisibility = 0
duration = 0
supply = 100'000'000
isTransferable = true
isSupplyMutable = false
isRestrictable = false

[distribution>jz:gas]
{{#cat_currency_distribution}}
{{address}} = {{amount}}
{{/cat_currency_distribution}}

[mosaic>jz:jzj]

divisibility = 6
duration = 0
supply = 100'000'000'000'000
isTransferable = true
isSupplyMutable = true
isRestrictable = false

[distribution>jz:jzj]
{{#cat_harvest_distribution}}
{{address}} = {{amount}}
{{/cat_harvest_distribution}}
