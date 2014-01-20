From: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [PATCH v7 1/7] VFS: Introduce new O_DENY* open flags
Date: Mon, 20 Jan 2014 13:34:24 +0000
Message-ID: <20140120133424.09328108@alan.etchedpixels.co.uk>
References: <1389953232-9428-1-git-send-email-piastry@etersoft.ru>
	<1389953232-9428-2-git-send-email-piastry@etersoft.ru>
	<20140117181847.6c1f3831@alan.etchedpixels.co.uk>
	<CAKywueT=JsTkNC+w-vrN0ftam7F8Eqb8DXJ0w2G4q9vnt0hVNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux NFS Mailing list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueT=JsTkNC+w-vrN0ftam7F8Eqb8DXJ0w2G4q9vnt0hVNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> > (and why not just use EPERM, it has the meaning you want already) 
> We need to determine if we have a share reservation error to map it
> accurately in file servers and wine.

Ok

> > Shouldn't this also check for CAP_SYS_DAC or some similar permission so
> > that root can override such a mess (eg to fix full disks in an
> > emergency) ?
> 
> May be it's better to let root an ability to remount the system
> without sharelock mount option and then fix an emergency?

Doesn't that involve breaking the service for all users of the system
relying upon those locks, while root being allowed to ignore the locks
does not ?

Alan
