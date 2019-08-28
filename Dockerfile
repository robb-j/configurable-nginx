FROM nginx:1.17.3-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY ["entrypoint.sh", "/"]
CMD [ "sh", "/entrypoint.sh" ]
