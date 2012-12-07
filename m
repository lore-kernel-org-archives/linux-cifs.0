From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Date: Fri, 7 Dec 2012 16:34:58 +0000
Message-ID: <20121207163458.435f676a@pyramind.ukuu.org.uk>
References: <1354818391-7968-1-git-send-email-piastry@etersoft.ru>
	<20121206194949.7ab20d56@pyramind.ukuu.org.uk>
	<20121206195752.GA18585@samba2>
	<CAH2r5msoPiu7wz-HjnnqTxeBLVEQiMYSnLMaZ+dEr11j6Fo4Ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msoPiu7wz-HjnnqTxeBLVEQiMYSnLMaZ+dEr11j6Fo4Ew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> I suspect that WINE would have the same need

Tricky - Wine needs to enforce this behaviour solely between Wine and
the file server, Trying to muck up non emulated local behaviour would be
a bad mistake.

One way perhaps to look at this is you want some tasks to be able to *opt
in* to this behaviour.

First however I think we need a much better description of the setup that
uses them and why it matters.
