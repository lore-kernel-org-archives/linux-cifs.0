From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH v2] CIFS: Print message when attempting a mount
Date: Sat, 6 Oct 2018 14:09:30 -0500
Message-ID: <CAH2r5mvXVDfYdJxPKLRJ0QAb_6mUHo4cfhxmkA7c19_GOR0p_Q@mail.gmail.com>
References: <ad6b338c900a17c4ecb1655a42b954221f242be2.1538480816.git.rfreire@redhat.com>
 <CAH2r5mtu9XbQfR=QevDqu36ZRYah1hrRGSQyynCfr82PRyunwQ@mail.gmail.com>
 <194690850.32402710.1538508513975.JavaMail.zimbra@redhat.com>
 <CAH2r5ms814MUNWVZNfCTuSO2LQZsmCs5N1nwgdVuhxtMctRE3Q@mail.gmail.com>
 <697659653.32427271.1538515234390.JavaMail.zimbra@redhat.com>
 <CAH2r5muV-vC6twZbNQQ3DHoXJTdaUwhzZi7YH+rhxr0BiMseJQ@mail.gmail.com> <633521295.32428133.1538517226400.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
To: rfreire@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <633521295.32428133.1538517226400.JavaMail.zimbra@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Oct 2, 2018 at 4:53 PM Rodrigo Freire <rfreire@redhat.com> wrote:
>
> Hi hi again Steve \o
>
> I do see potential for a ftrace rewrite for the cifs_dbg messages.

Was looking at this on current kernels and debugging mount is probably
fine for developers (or users) - plenty of debug messages get printed
via the dynamic ftrace points.  In practice some would prefer less
noisy trace logs so the minimum set for some would be something like
this (which already works with current cifs).  If we want to add some
default log messages on mount to dmesg instead of the trace-cmd log,
maybe we should log them at a slightly less noisy level (as we see
with xfs and btrfs) so they will be more log friendly


root@smf-Thinkpad~/# trace-cmd record -e smb3_enter* -e smb3_exit*
Hit Ctrl^C to stop recording


root@smf-Thinkpad:~/# trace-cmd show
# tracer: nop
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
      mount.cifs-14199 [002] .... 97642.728411: smb3_enter:
cifs_mount: xid=20
      mount.cifs-14199 [002] .... 97642.728669: smb3_enter:
cifs_get_smb_ses: xid=21
      mount.cifs-14199 [003] .... 97642.742336: smb3_exit_done:
cifs_get_smb_ses: xid=21
      mount.cifs-14199 [003] .... 97642.742343: smb3_enter:
cifs_setup_ipc: xid=22
      mount.cifs-14199 [003] .... 97642.742530: smb3_exit_done:
cifs_setup_ipc: xid=22
      mount.cifs-14199 [003] .... 97642.742532: smb3_enter:
cifs_get_tcon: xid=23
      mount.cifs-14199 [003] .... 97642.742674: smb3_exit_done:
cifs_get_tcon: xid=23
      mount.cifs-14199 [003] .... 97642.743267: smb3_exit_done:
cifs_mount: xid=20
      mount.cifs-14199 [003] .... 97642.743311: smb3_enter:
cifs_root_iget: xid=24
      mount.cifs-14199 [003] .... 97642.743471: smb3_exit_done:
cifs_root_iget: xid=24




-- 
Thanks,

Steve
