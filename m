From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: CIFS module build verification system
Date: Mon, 18 Aug 2014 21:46:44 +0400
Message-ID: <CAKywueRrd4ivRgyqkkYFVL47D-B4FwxyALg2xraQkybucVyeog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

During the second part of the GSoC program of this year I has been
working on build verification system for CIFS kernel module.

Now, I got the system ready to test module with Cthon and XFS test
suites. Both suites has some tests (that are not working with CIFS)
disabled. I was trying to make it easier to add new test suites
further.

The system is based on bash scripts that can be run from cron. The
scripts automatically pull the recent changes from the predefined git
repository, build the module and run tests against it.

The git repo for build verification system scripts:
http://git.altlinux.org/people/piastry/public/?p=cifs-tests.git;a=summary

The git repo for patched Cthon tests (merged by Steve Dickson into his tree):
http://git.altlinux.org/people/piastry/public/?p=cthon04.git;a=summary

The git repo for patched XFS tests:
http://git.altlinux.org/people/piastry/public/?p=xfstests.git;a=summary

-- 
Best regards,
Pavel Shilovsky.
