/*
 * @Author: 21克的爱情
 * @Date: 2020-06-19 16:54:05
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-06-21 13:37:45
 * @Description: 
 */ 
// stats.js: JavaScript Performance Monitor
// const stats = new Stats();
// stats.showPanel(0); // 0: fps, 1: ms, 2: mb, 3+: custom
// document.body.appendChild(stats.dom);
// function animate() {
//     stats.begin();
//     // monitored code goes here
//     stats.end();

//     requestAnimationFrame(animate);
// }
// requestAnimationFrame(animate);

initPlayers();

function initPlayers() {
    window.dp = new DPlayer({
        container: document.getElementById('dplayer'),
        preload: 'none',
        autoplay: false,
        theme: '#FADFA3',
        loop: true,
        screenshot: true,
        airplay: true,
        hotkey: true,
        // logo: 'https://i.loli.net/2019/06/06/5cf8c5d94521136430.png',
        volume: 0.2,
        mutex: true,
        video: {
            url: 'https://api.dogecloud.com/player/get.mp4?vcode=5ac682e6f8231991&userId=17&ext=.mp4',
            pic: 'https://i.loli.net/2019/06/06/5cf8c5d9c57b510947.png',
            thumbnails: 'https://i.loli.net/2019/06/06/5cf8c5d9cec8510758.jpg',
            type: 'auto'
        },
        subtitle: {
            url: 'https://s-sh-17-dplayercdn.oss.dogecdn.com/hikarunara.vtt',
            type: 'webvtt',
            fontSize: '25px',
            bottom: '10%',
            color: '#b7daff'
        },
        danmaku: {
            id: '9E2E3368B56CDBB4',
            api: 'https://api.prprpr.me/dplayer/',
            token: 'tokendemo',
            maximum: 3000,
            user: 'DIYgod',
            bottom: '15%',
            unlimited: true
        }
    });
}