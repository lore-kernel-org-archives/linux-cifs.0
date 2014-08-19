From: David Disseldorp <ddiss@suse.de>
Subject: Re: CIFS module build verification system
Date: Tue, 19 Aug 2014 17:28:33 +0200
Message-ID: <20140819172833.591d43ca@f163.suse.de>
References: <CAKywueRrd4ivRgyqkkYFVL47D-B4FwxyALg2xraQkybucVyeog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>, Steve French <smfrench@gmail.com>
To: Pavel Shilovsky <pshilovsky@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAKywueRrd4ivRgyqkkYFVL47D-B4FwxyALg2xraQkybucVyeog@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

Hi Pavel,

On Mon, 18 Aug 2014 21:46:44 +0400, Pavel Shilovsky wrote:

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

Thanks for putting this together!

> The git repo for build verification system scripts:
> http://git.altlinux.org/people/piastry/public/?p=cifs-tests.git;a=summary
> 
> The git repo for patched Cthon tests (merged by Steve Dickson into his tree):
> http://git.altlinux.org/people/piastry/public/?p=cthon04.git;a=summary

I haven't looked at your cifs-tests or cthon04 tests yet.

> The git repo for patched XFS tests:
> http://git.altlinux.org/people/piastry/public/?p=xfstests.git;a=summary

        nfs)
                export MKFS_OPTIONS=$NFS_MKFS_OPTIONS
                ;;
+       nfs)
+               export MKFS_OPTIONS=$CIFS_MKFS_OPTIONS
+               ;;

Should be "cifs)".

Would be good to add an auto group to tests/cifs/group, which could be
added to as existing tests are made to pass on cifs.

Also, a brief description in README of how to run against a cifs mount
would be useful. E.g.
http://git.samba.org/?p=ddiss/fstests.git;a=commitdiff;h=b99c5b12799b4db3edcb6430e000db6afb5db9a9
