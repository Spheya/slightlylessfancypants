# pants, but slightly less fancy

[fancypants](https://github.com/Ancientkingg/fancyPants) is slow

[lessfancypants](https://github.com/Godlander/lessfancypants) is less

so here i present to you, *slightly\* less fancy pants

(it's lessfancypants but with features from fancypants)

## usage:

look at [fancypants'](https://github.com/Ancientkingg/fancyPants) guide, basically everything is the same except for the notable differences that
**you cannot assign a custom dye colour to the armour set**, also the texture resolution is set in the config file at `assets\minecraft\shaders\include\slightlylessfancypants_config.glsl`

the integer display color determines which texture to use, starting from 0

for example, to equip the second custom chestplate:

`/item replace entity @s armor.chest with leather_chestplate{display:{color:1}}`

*colors beyond total number of armor textures will default to use the first texture, but with tint color applied*

when the glowing effect is applied, the first custom armor texture is what glowing outline will show

## performance:

read [lessfancypants'](https://github.com/Godlander/lessfancypants) readme file on why this is better

because this adds a few features from fancypants, this is slower than lessfancypants, but should be more performant than fancypants

## feature comparison:

|  | lessfancypants | slightlylessfancypants | fancypants |
|---|---|---|---|
| performance | fast | medium | slow |
| custom dye colours |  |  | x |
| option to enable dye tint |  |  | x |
| animations |  | x | x |
| emissivity |  | x | x |
| custom armour sets | x | x | x |
| properly handles vanilla leather overlay |  | x |  |
