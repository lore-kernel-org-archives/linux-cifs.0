From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Date: Fri, 14 Dec 2012 18:12:44 +0400
Message-ID: <CAKywueSN++ZCNJ1zbET_axuwXd2ZujvSof9H82E3AdeZWY_BgQ@mail.gmail.com>
References: <1354818391-7968-1-git-send-email-piastry@etersoft.ru>
	<20121207161602.GA17710@infradead.org>
	<495d17310e0a687d446afc86def0f058@office.etersoft.ru>
	<20121212083401.GW5010@snowdrop.l8s.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: David Laight <david-SsvC4kVYujlaa/9Udqfwiw@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121212083401.GW5010-y8aDsudeyGZKtrsfIrZdgrVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/12/12 David Laight <david-SsvC4kVYujlaa/9Udqfwiw@public.gmane.org>:
> On Sat, Dec 08, 2012 at 12:43:14AM +0400, Pavel Shilovsky wrote:
>>
>> The problem is the possibility of denial-of-service attacks here. We
>> can try to prevent them by:
>
> FWIW I already see a DoS 'attack'.
> I have some filestore shared using NFS (to Linux and Solaris) and
> using samba (to Windows).
>
> I use it for release builds of a product to ensure the versions
> built for the different operating systems match, and because some
> files have to be built on an 'alien' system (eg gcc targetted at
> embedded card).
>
> I can't run the windows build at the same time as the others
> because the windows C compiler manages to obtain exclusive access
> to the source files - stopping the other systems from reading them.

We can make this feature (passing O_DENY* flags received from clients
to filesystem) can be turned on/off on Samba/NFS server to let this
particular use case work. In general, I think we really need to be
sure that nobody has a read access for files that a Windows process
opened with O_DENYREAD (because there can be important reasons for the
Windows process to do so).

-- 
Best regards,
Pavel Shilovsky.
