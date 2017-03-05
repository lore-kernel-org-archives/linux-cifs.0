From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cifs:for-next 1/1] fs/cifs/smb2misc.c:689:14-41: WARNING: casting
 value returned by memory allocation function to (struct close_cancelled_open
 *) is useless.
Date: Mon, 6 Mar 2017 06:42:41 +0800
Message-ID: <201703060637.SQGYTNgP%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   ec1a4dc5ea28ca9cde4ba5c99447d5bc7929aaa9
commit: ec1a4dc5ea28ca9cde4ba5c99447d5bc7929aaa9 [1/1] Handle mismatched open calls


coccinelle warnings: (new ones prefixed by >>)

>> fs/cifs/smb2misc.c:689:14-41: WARNING: casting value returned by memory allocation function to (struct close_cancelled_open *) is useless.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
