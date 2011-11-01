From: Nick Davis <nick-fUoCq3+lmYBnK6aPwh9DPQ@public.gmane.org>
Subject: Linux CIFS corruption bug in kernel 3.0.4 and 3.1
Date: Tue, 1 Nov 2011 10:09:26 -0500
Message-ID: <CAGc=Oh8GGXw6itfAo5-x6CpbwtK1TQeZrerx_zPrC4qABR2m6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I've recently noticed a corruption bug in the Linux kernel CIFS client
that ships with Ubuntu 11.10 (kernel 3.0, based on upstream 3.0.4).
I've filed a bug report with the details on Launchpad
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/879228

As suggested in the Launchpad bug comments, I installed a custom
kernel based on the upstream 3.1, but after testing the bug is still
present. =C2=A0It was then suggested that I file a bug report with the
upstream subsystem maintainer.

Let me know if I can provide any further information, or if I should
report this issue somewhere else.

Thanks,

Nick Davis
PhD Candidate in Computer Science
Doctoral Researcher in Bioinformatics
University of Tulsa
Department of Mathematical and Computer Sciences
nick-fUoCq3+lmYBnK6aPwh9DPQ@public.gmane.org
