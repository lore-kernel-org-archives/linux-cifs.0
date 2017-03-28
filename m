From: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] Various fixes and improvements for SMB CA
Date: Wed, 29 Mar 2017 00:26:50 +0100
Message-ID: <1490743614-5439-1-git-send-email-germano.percossi@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patches series is in increasing order of importance.
SMB Continuous Availability is broken when the server replies
with errors or unexpected packets during the reconnect phase.

The first patch is a small improvement to align the reconnect
thread with the other threads (e.g. echo) that are not queued
immediately.
In this case the value is set to 2 seconds but it could be configured
using command line arguments, as it is done with echo_interval.
If making it configurable is the best choice I'll be happy to do it.

The second one will make the reconnect thread reschedule itself in
case of errors.
Doing this, reconnect does not need to wait for the echo thread for
being rescheduled.
In this case, too, there is no point in rushing the reconnection.

The third one is to cope with STATUS_BAD_NETWORK_NAME sent by some
servers during the node failover.
This has been observed with some Microsoft Windows servers and
Microsoft confirmed that this could be the case if reconnect requests
happen within few seconds from the failover start.
Previous patches were limiting the reconnection aggressiveness to
limit the rate of errors during reconnect.
Setting the flag during reconnect will make any other attempt fail,
given nothing wil clear that flag.
I did not see any case where retaining the flag is going to be useful:
passing a bad share name during mount will fail regardless, while
retaining it will cause problems to reconnect.
I could be missing something, though.

The fourth patch is clearly a bug fix preventing the user space program
hang forever waiting for read and write events that will never come.

Patches are attached or available here on this branch
https://github.com/germanop/linux/commits/fix-ca-reconnect

As a side note, I think some of the return codes from cifs_reopen_file
need to be revisited.

Germano Percossi (4):
  CIFS: queue 'reconnect' thread with a delay
  CIFS: reconnect thread reschedule itself
  CIFS: remove bad_network_name flag
  CIFS: store results of cifs_reopen_file to avoid infinite wait

 fs/cifs/cifsglob.h |  1 -
 fs/cifs/file.c     |  6 +++---
 fs/cifs/smb2pdu.c  | 21 +++++++++++++--------
 3 files changed, 16 insertions(+), 12 deletions(-)

-- 
2.7.4
