From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Tunable timeout in cifs module.
Date: Tue, 20 Oct 2015 13:50:10 +0530
Message-ID: <1445329210.10711.13.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "French, Steve" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Steve/linux-cifs,

We have received a request to make the timeout in the cifs module
tunable.

I have gone through the code to understand timeouts in the cifs client.
http://sprabhu.blogspot.in/2015/08/investigation-into-effects-of-server
.html

The way to allow user settable timeout values is to make the value of
 SMB_ECHO_INTERVAL tunable. Do you think this is a good idea?

Sachin Prabhu
