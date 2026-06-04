// ==========================================
// CONFIGURAÇÕES DO PROJETO (VARIÁVEIS LOCAIS)
// ==========================================
// 1. Tenta primeiro o caminho relativo local (super rápido)
const LOCAL_SLIDES_PATH = "../wish_final_project/05_presentation/slides/wish_sustainability_2020_img/";

// 2. Link de segurança do GitHub (caso o caminho relativo falhe no GitHub Pages)
const BACKUP_GITHUB_URL = "https://github.com/gustavocs97/wish_dataset_bytes4future/tree/main/wish_final_project/05_presentation/slides/wish_sustainability_2020_img";

const CONFIG_TOTAL_SLIDES = 13;

// Dados da Equipe usando caminhos relativos locais e alinhamentos de imagem (object-position)
const CONFIG_TEAM = [
    {
        name: "Letícia Alexandre",
        role: "Análise de Sustentabilidade",
        linkedin: "https://linkedin.com/in/letícia-alexandre",
        avatarUrl: "avatars/leticia.jpg",
        objectPosition: "50% 50%"
    },
    {
        name: "Gustavo Carvalho",
        role: "Análise de Qualidade",
        linkedin: "https://linkedin.com/in/gustavoccsilva/",
        avatarUrl: "avatars/gustavo.jpg",
        objectPosition: "50% 50%"
    },
    {
        name: "Ricardo Neves",
        role: "Análise de Fast Fashion",
        linkedin: "https://www.linkedin.com/in/ricardo-neves-746a04290/",
        avatarUrl: "avatars/ricardo.jpg",
        objectPosition: "50% 5%"
    }
];

// Caminho relativo para a logo do Bootcamp
const CONFIG_LOGO_URL = "avatars/logo_bytes4future.png";

// ==========================================
// ESTADO INTERNO E LÓGICA DO SISTEMA
// ==========================================
let currentState = {
    current: 1,
    total: CONFIG_TOTAL_SLIDES,
    useBackupMode: false // Fica true se o caminho local falhar
};

// Mapeamento dos elementos do HTML
const imgDisplay = document.getElementById('slide-display');
const pageText = document.getElementById('page-indicator');
const prevBtn = document.getElementById('prev-btn');
const nextBtn = document.getElementById('next-btn');
const fullscreenBtn = document.getElementById('fullscreen-btn');
const contactsListContainer = document.getElementById('contacts-list');

// Converte URL normal do GitHub para RAW
function convertToRaw(url) {
    let clean = url.trim().replace(/\/$/, "");
    if (clean.includes("github.com")) {
        clean = clean.replace("github.com", "raw.githubusercontent.com")
                     .replace("/tree/", "/");
    }
    return clean.endsWith("/") ? clean : clean + "/";
}

// Constrói os cartões de contato dinamicamente com as fotos locais
function renderTeam() {
    contactsListContainer.innerHTML = ""; 
    
    CONFIG_TEAM.forEach(member => {
        const cardHtml = `
            <a href="${member.linkedin}" target="_blank" class="contact-card">
                <div class="avatar-container">
                    <img src="${member.avatarUrl}" 
                         alt="${member.name}" 
                         class="avatar-img" 
                         style="object-position: ${member.objectPosition};"
                         onerror="this.src='https://ui-avatars.com/api/?name=${encodeURIComponent(member.name)}&background=00f2fe&color=0f172a'">
                </div>
                <div class="info">
                    <span class="name">${member.name}</span>
                    <span class="role">${member.role}</span>
                </div>
                <i class="fa-brands fa-linkedin"></i>
            </a>
        `;
        contactsListContainer.innerHTML += cardHtml;
    });
}

// Troca o ícone padrão pela logo oficial do Bootcamp no topo
function renderLogo() {
    const logoIcon = document.querySelector('.sidebar-header .logo i');
    if (logoIcon) {
        const imgLogo = document.createElement('img');
        imgLogo.src = CONFIG_LOGO_URL;
        imgLogo.alt = "Bytes4Future";
        imgLogo.style.width = "32px";
        imgLogo.style.height = "32px";
        imgLogo.style.borderRadius = "6px";
        imgLogo.style.objectFit = "cover";
        
        logoIcon.replaceWith(imgLogo);
    }
}

// Atualiza a exibição do slide na tela
function updateUI() {
    const filename = `${currentState.current}.jpg`;

    if (!currentState.useBackupMode) {
        // Modo Normal: Tenta carregar localmente via caminho relativo
        imgDisplay.src = `${LOCAL_SLIDES_PATH}${filename}`;
    } else {
        // Modo Backup: Se falhou antes, usa direto a URL RAW do GitHub
        const rawBackupUrl = convertToRaw(BACKUP_GITHUB_URL);
        imgDisplay.src = `${rawBackupUrl}${filename}`;
    }
    
    const currentStr = currentState.current.toString().padStart(2, '0');
    const totalStr = currentState.total.toString().padStart(2, '0');
    pageText.textContent = `${currentStr} / ${totalStr}`;
    
    prevBtn.disabled = currentState.current === 1;
    nextBtn.disabled = currentState.current === currentState.total;
}

// GATILHO INTELIGENTE: Se a imagem falhar (Erro 404), ele muda para o modo Backup
imgDisplay.addEventListener('error', () => {
    if (!currentState.useBackupMode) {
        console.warn("Caminho relativo falhou. Ativando modo de segurança via GitHub RAW...");
        currentState.useBackupMode = true;
        updateUI(); // Força uma nova tentativa com o link do Git convertido
    }
});

// Eventos de clique para paginação
nextBtn.addEventListener('click', () => {
    if (currentState.current < currentState.total) {
        currentState.current++;
        updateUI();
    }
});

prevBtn.addEventListener('click', () => {
    if (currentState.current > 1) {
        currentState.current--;
        updateUI();
    }
});

// Ativar/Desativar modo Tela Cheia
fullscreenBtn.addEventListener('click', () => {
    if (!document.fullscreenElement) {
        document.documentElement.requestFullscreen().catch(err => {
            console.error(`Erro ao tentar ativar Fullscreen: ${err.message}`);
        });
    } else {
        document.exitFullscreen();
    }
});

// Atalhos de teclado (Setas direcionais Esquerda/Direita)
document.addEventListener('keydown', (e) => {
    if (e.key === "ArrowRight" && currentState.current < currentState.total) nextBtn.click();
    if (e.key === "ArrowLeft" && currentState.current > 1) prevBtn.click();
});

// Inicialização da Aplicação
window.onload = () => {
    renderLogo();
    renderTeam();
    updateUI();
};