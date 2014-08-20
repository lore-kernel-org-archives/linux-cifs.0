From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: CIFS module build verification system
Date: Wed, 20 Aug 2014 11:32:59 +0400
Message-ID: <CAKywueTMGq3tmf5fo5aWPUA888TgiKWHyRH=hQxHjRQ3in5gUQ@mail.gmail.com>
References: <CAKywueRrd4ivRgyqkkYFVL47D-B4FwxyALg2xraQkybucVyeog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRrd4ivRgyqkkYFVL47D-B4FwxyALg2xraQkybucVyeog-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-08-18 21:46 GMT+04:00 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> Hi,
>
> During the second part of the GSoC program of this year I has been
> working on build verification system for CIFS kernel module.
>
> Now, I got the system ready to test module with Cthon and XFS test
> suites. Both suites has some tests (that are not working with CIFS)
> disabled. I was trying to make it easier to add new test suites
> further.
>
> The system is based on bash scripts that can be run from cron. The
> scripts automatically pull the recent changes from the predefined git
> repository, build the module and run tests against it.
>
> The git repo for build verification system scripts:
> http://git.altlinux.org/people/piastry/public/?p=cifs-tests.git;a=summary
>
> The git repo for patched Cthon tests (merged by Steve Dickson into his tree):
> http://git.altlinux.org/people/piastry/public/?p=cthon04.git;a=summary
>
> The git repo for patched XFS tests:
> http://git.altlinux.org/people/piastry/public/?p=xfstests.git;a=summary

Hi Steve, David,

Thank you for your notes and suggestions!

Do you understand right that I can squash David's commit (started with
"SQUASH") into my patch?

Not sure about group file. CIFS (as NFS) doesn't have it's own tests
now. Do you mean to add "test/cifs" directory with an empty (except a
commented header) group file inside (to let us add cifs specific tests
in future)?

-- 
Best regards,
Pavel Shilovsky.
