FROM public.ecr.aws/g6k1i6y8/cv-builder
COPY cv.tex .
RUN pdflatex -interaction=nonstopmode cv.tex || true

FROM node
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY --from=0 /cv.pdf ./
COPY . .
EXPOSE 80
CMD [ "node", "server.js" ]