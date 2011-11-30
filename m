From: =?UTF-8?Q?Johannes_Thr=C3=A4n?= <johannes.thraen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: vim reports file having changed
Date: Wed, 30 Nov 2011 15:25:01 +0100
Message-ID: <CAFbNW2Fv58h_r1rmtk0rHg+uJ0C9i1Rtoy2DEDm-Hxw-ZtK_mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,

I reported this before here, it somehow went under. So I'll try again:

When I open a file which is located on a cifs-mounted windows share
with vim, vim will after some time always report the file as having
changed upon saving, regardless whether it has actually changed or
not.

I reported this also to the vim maintainer who told me, there he
doesn't know of a similar problem with samba. Ergo it's probably a
problem with cifs.
I work on a daily basis with mentioned setup, so I would be vary glad
to help resolve it.

mount.cifs -v gives 4.5, I use kubuntu 11.04 and vim 7.2

best regard, Johannes
