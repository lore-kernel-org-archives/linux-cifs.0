From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: build failure after merge of the cifs tree
Date: Wed, 30 Nov 2016 09:27:42 +1100
Message-ID: <20161130092742.0f1cc03b@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/cifs/connect.c: In function 'cifs_find_tcon':
fs/cifs/connect.c:2610:11: error: 'struct cifs_tcon' has no member named 'snapshot_time'
   if (tcon->snapshot_time != volume_info->snapshot_time)
           ^
fs/cifs/connect.c: In function 'cifs_get_tcon':
fs/cifs/connect.c:2681:8: error: 'struct cifs_tcon' has no member named 'snapshot_time'
    tcon->snapshot_time = volume_info->snapshot_time;
        ^

Caused by commit

  36c659cf9241 ("SMB3: parsing for new snapshot timestamp mount parm")

CONFIG_CIFS_SMB2 is not set for this build ...

I have used the cifs tree from next-20161129 for today.

-- 
Cheers,
Stephen Rothwell
