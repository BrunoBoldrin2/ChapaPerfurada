# Use uma imagem base com suporte a Python e Jupyter
FROM jupyter/base-notebook:latest

# Instale pacotes adicionais, incluindo sudo
USER root
RUN apt-get update && \
    apt-get install -y sudo && \
    # Adicione outros pacotes necessários aqui
    pip install --no-cache-dir \
    numpy \
    pandas \
    matplotlib \
    # Adicione outros pacotes Python necessários aqui
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure o sudo para o usuário jovyan
RUN echo "jovyan ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jovyan

# Copie os arquivos do repositório para dentro do contêiner
COPY . /home/jovyan/work/

# Defina o diretório de trabalho
WORKDIR /home/jovyan/work/

# Instale pacotes do requirements.txt se existir
COPY requirements.txt /home/jovyan/work/
RUN pip install --no-cache-dir -r requirements.txt

# Adicione o script postBuild, se necessário
COPY postBuild /home/jovyan/work/
RUN chmod +x /home/jovyan/work/postBuild

# Defina o comando padrão para iniciar o Jupyter Notebook
CMD ["start-notebook.sh"]
