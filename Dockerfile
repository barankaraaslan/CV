FROM archlinux AS pdf-builder

RUN pacman -Syu --noconfirm
RUN pacman -Syu --noconfirm base-devel git

COPY install.sh .
RUN bash install.sh
COPY cv.tex .
RUN pdflatex -interaction=nonstopmode cv.tex || true

FROM node
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY --from=pdf-builder /cv.pdf ./
COPY . .
EXPOSE 3000
CMD [ "node", "server.js" ]