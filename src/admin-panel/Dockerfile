FROM node:16-alpine As builder
WORKDIR /usr/src/app
COPY package*.json ./
# Install yarn and other dependencies via apk
RUN apk add --update --no-cache g++ make python3 && ln -sf python3 /usr/bin/python && rm -rf /var/cache/apk/*
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
RUN npm install --global node-gyp && npm install --only=development
COPY . .
RUN npm run build


FROM nginx:1.15.8
EXPOSE 80
# COPY conf/default.conf /etc/nginx/conf.d/
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /usr/src/app/dist/admin-panel /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
