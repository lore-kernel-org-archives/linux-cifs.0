From: =?UTF-8?Q?Johannes_Thr=C3=A4n?= <johannes.thraen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: file changed in vim when opened in another instance
Date: Wed, 26 Oct 2011 20:14:18 +0200
Message-ID: <CAFbNW2Fq349fCqYYaULjYo76r5gMQonqOGCe6_ixs6BtrPaz-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

when I open a cifs-share located file with vim which is opened
somewhere else (e.g. nano) I always get a message about the file
having changed upon saving it (in vim), regardless whether it has
changed or not.

Is this intended? I often edit windows-originated source-files with
vim and debug/execute them with some IDE on windows, opening them
simultaneously there.

This happens only on cifs-shares so I reckon it's a cifs and not a vim
problem, but I could very well be wrong here.

Thanks, Johannes
