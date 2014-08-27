From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 0/3] CIFS support for XFS test suite
Date: Wed, 27 Aug 2014 10:59:13 +0400
Message-ID: <CAKywueTQeA4mi-54Bsz3GgY7ykw3-pDNSfSkXn=tDvPnDzPa3g@mail.gmail.com>
References: <1409084918-17764-1-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409084918-17764-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-08-27 0:28 GMT+04:00 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> These are patches that adds CIFS support to XFS tests.
>
> The first patch changes generic/013 test to use mount options provided for $TEST_DEV for remount. The second patch adds "-cifs" command line argument and CIFS specific variables. The third patch disables tests that need POSIX behavior from filesystem for unix cifs mounts.
>
> With these patches applied, most of generic/shared $TEST_DEV tests pass for the recent kernel cifs module.
>
> Pavel Shilovsky (3):
>   generic/013: encapsulate remount during cleanup
>   common: add cifs support
>   cifs: skip tests that need POSIX support for nounix mounts

Patches are also available in a git repository:
http://git.altlinux.org/people/piastry/public/?p=xfstests.git;a=shortlog;h=refs/heads/v2

-- 
Best regards,
Pavel Shilovsky.
