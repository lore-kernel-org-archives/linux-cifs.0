From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: SMB3 credits do match expected server values for cifs.ko
Date: Fri, 23 Sep 2016 01:59:00 -0500
Message-ID: <CAH2r5mt82G86whAzVGMWM_ZPtUGri35D0_hHVf=1DXYbBUSMtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
        Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We had been noticing that the SMB3 credits that the cifs.ko client was
reporting on mounts to Samba (and Windows) were two less than expected
(in the new debug line displayed for SMB3 sessions in
/proc/fs/cifs/DebugData for total remaining credits remaining on the
session to the server) but it turned out the total is correct after
all   The cifs client reserves one credit for oplock and one for echo
so the number of remaining credits displayed will be two less than the
overall total of credits the client has been granted.  If you include
the two reserved credits (that the client keeps for lease and echo),
then the totals of credits that the client and server report matches.

-- 
Thanks,

Steve
