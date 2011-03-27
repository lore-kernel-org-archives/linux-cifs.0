From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Does fscache work already??
Date: Sun, 27 Mar 2011 13:05:29 +0200
Message-ID: <AANLkTimQbY+kizqhrV3k5NnCzQMWJRN4XxTWxzB237Ts@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I've just installed cachefilesd from source, got it running,
configured the kernel, to make it support fscache,
and mounted some shares using cifs.

I do not see anything happen. No files in /var/cache/fscache/cache/....
It's mounted using autofs.

I have cifs-utils 4.8 installed, and latest kernel 2.6.38.1.

Is a commandline option required or something?

Stef
