From: Josh Pettett <jpettett-qZWgbgh2FR7QT0dZR+AlfA@public.gmane.org>
Subject: Can I reduce the CIFS client connection timeout?
Date: Thu, 4 Jan 2018 00:45:44 -0500
Message-ID: <CA+BABmYNvYW48pXnSkqGnpO9yj3oLb1jf1MPXbNcVJi+3a6sRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

We have a use case in which we want the the CIFS mount to quickly
timeout and return an error on the client side if the remote server is
down.  This error would then trigger failure-mode logic in our
application. It appears that an error is returned if the server is
unreachable for 120 seconds, but we want the timeout to occur after
about 15 seconds.  Is this value configurable anywhere?
