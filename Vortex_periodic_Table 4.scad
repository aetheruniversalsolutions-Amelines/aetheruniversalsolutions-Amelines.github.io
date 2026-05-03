// ==========================================
// EL VÓRTICE QUÍMICO - CÓDICE ÆTHER (3D)
// Arquitectura de Estado Sólido (Parastiquias 13x21)
// ==========================================

$fn = 30; // Resolución de las esferas

// Símbolos de los 118 elementos
elements = [
    "H","He","Li","Be","B","C","N","O","F","Ne",
    "Na","Mg","Al","Si","P","S","Cl","Ar","K","Ca",
    "Sc","Ti","V","Cr","Mn","Fe","Co","Ni","Cu","Zn",
    "Ga","Ge","As","Se","Br","Kr","Rb","Sr","Y","Zr",
    "Nb","Mo","Tc","Ru","Rh","Pd","Ag","Cd","In","Sn",
    "Sb","Te","I","Xe","Cs","Ba","La","Ce","Pr","Nd",
    "Pm","Sm","Eu","Gd","Tb","Dy","Ho","Er","Tm","Yb",
    "Lu","Hf","Ta","W","Re","Os","Ir","Pt","Au","Hg",
    "Tl","Pb","Bi","Po","At","Rn","Fr","Ra","Ac","Th",
    "Pa","U","Np","Pu","Am","Cm","Bk","Cf","Es","Fm",
    "Md","No","Lr","Rf","Db","Sg","Bh","Hs","Mt","Ds",
    "Rg","Cn","Nh","Fl","Mc","Lv","Ts","Og"
];

// Función para obtener la Raíz Tesla (3, 6, 9) según la Octava
function get_tesla(z) =
    (z <= 2)  ? 9 :
    (z <= 10) ? 3 :
    (z <= 18) ? 6 :
    (z <= 36) ? 9 :
    (z <= 54) ? 3 :
    (z <= 86) ? 6 : 9;

// Asignar colores según la resonancia Tesla (Mantenido para visualización 3D)
function get_color(t) =
    (t == 3) ? [1.0, 0.2, 0.4] :
    (t == 6) ? [0.2, 0.8, 1.0] :
               [0.8, 0.2, 1.0];

// Parámetros de expansión del Vórtice
angle_step = 137.508; // Ángulo Áureo
radius_factor = 6.0;  // Qué tan ancha es la espiral
height_factor = 1.5;  // Qué tan alto es el vórtice (z)

// --- NUEVO: Función matemática para calcular coordenadas X, Y, Z exactas ---
function get_pos(i) = [
    (radius_factor * sqrt(i + 1)) * cos((i + 1) * angle_step),
    (radius_factor * sqrt(i + 1)) * sin((i + 1) * angle_step),
    height_factor * (i + 1)
];

// --- NUEVO: Módulo para trazar las conexiones físicas de la Matriz (Líneas 3D) ---
module line3d(p1, p2, thickness=0.4) {
    hull() {
        translate(p1) sphere(r=thickness, $fn=10);
        translate(p2) sphere(r=thickness, $fn=10);
    }
}

module draw_vortex() {
    for (i = [0 : 117]) {
        z_index = i + 1;
        p_current = get_pos(i);
        
        t_root = get_tesla(z_index);
        col = get_color(t_root);
        
        // 1. Dibujar el Nodo del Elemento (La Esfera)
        translate(p_current) {
            color(col) sphere(r=3.5);
            
            // 2. Texto del símbolo flotando encima
            translate([0, 0, 5])
                rotate([0, 0, - (z_index * angle_step)]) // Para que sea legible
                color([1, 1, 1])
                linear_extrude(0.5)
                text(elements[i], size=3.5, halign="center", valign="center");
        }
        
        // --- 3. EL CANDADO GEODÉSICO: Trazar las Parastiquias 13x21 ---
        // Conexión Levógira (n + 13)
        if (i + 13 <= 117) {
            color([0.6, 0.6, 0.6]) // Color gris para la malla estructural
            line3d(p_current, get_pos(i + 13), 0.6);
        }
        
        // Conexión Dextrógira (n + 21)
        if (i + 21 <= 117) {
            color([0.6, 0.6, 0.6]) // Color gris para la malla estructural
            line3d(p_current, get_pos(i + 21), 0.6);
        }
    }
    
    // 4. El Cono de Succión (El fluido base del Æther)
    color([0.1, 0.2, 0.4, 0.2])
    translate([0, 0, 0])
    cylinder(h = height_factor * 118, r1 = 0, r2 = radius_factor * sqrt(118), $fn=50);
}

// Renderizar la escena
draw_vortex();
