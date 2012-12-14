From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Date: Fri, 14 Dec 2012 15:30:00 +0000
Message-ID: <20121214153000.62af6cbc@pyramind.ukuu.org.uk>
References: <1354818391-7968-1-git-send-email-piastry@etersoft.ru>
	<20121207161602.GA17710@infradead.org>
	<495d17310e0a687d446afc86def0f058@office.etersoft.ru>
	<20121212083401.GW5010@snowdrop.l8s.co.uk>
	<CAKywueSN++ZCNJ1zbET_axuwXd2ZujvSof9H82E3AdeZWY_BgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: David Laight <david-SsvC4kVYujlaa/9Udqfwiw@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSN++ZCNJ1zbET_axuwXd2ZujvSof9H82E3AdeZWY_BgQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> We can make this feature (passing O_DENY* flags received from clients
> to filesystem) can be turned on/off on Samba/NFS server to let this
> particular use case work. In general, I think we really need to be
> sure that nobody has a read access for files that a Windows process
> opened with O_DENYREAD (because there can be important reasons for the
> Windows process to do so).

It should only affect windows emulated tasks, nothing else. If you want
to do locking friendly behaviour you could also take lockf locks so that
Linux domain code that *wishes* to be nice in this area behaves the way
you want.

Without that you break so much stuff its a horrible idea (eg backups,
ubuntu one sync etc).

Alan
