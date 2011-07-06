From: Adam Williamson <awilliam-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: DFS referral patchset ("fix regressions when chasing DFS referrals
 at mount")
Date: Wed, 06 Jul 2011 10:42:04 -0700
Message-ID: <1309974124.1899.2.camel@adam>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sorry I'm not replying to the thread, I'm not subscribed to this list.
Just wanted to pass along that I tested Jeff's patch set - posted today
under the description "fix regressions when chasing DFS referrals at
mount" - and found it good. I reported the initial bug which got him
chasing this code, https://bugzilla.redhat.com/show_bug.cgi?id=717060 -
a CIFS mount that worked fine on my system with kernel 2.6.38 caused an
oops and did not work with 3.0 kernels. With the patch set applied,
there is no oops, and the mount succeeds. I do not have any other server
configs to test with, though, so I can't say I've done any particular
regression testing, only confirmed that it fixes my specific issue.
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Fedora Talk: adamwill AT fedoraproject DOT org
http://www.happyassassin.net
