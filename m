From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: [CIFS] fix static checker warning
Date: Mon, 18 May 2015 15:33:44 +0300
Message-ID: <20150518123344.GE32633@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


[ I recently changed the checker so now it gives a new warning about
  this old code. ]

Hello Steve French,

The patch 84ceeb962665: "[CIFS] fix static checker warning" from Jun
26, 2013, leads to the following static checker warning:

	fs/cifs/smb2pdu.c:136 smb2_hdr_assemble()
	warn: variable dereferenced before check 'tcon->ses->server' (see line 120)

fs/cifs/smb2pdu.c
   111          /* GLOBAL_CAP_LARGE_MTU will only be set if dialect > SMB2.02 */
   112          /* See sections 2.2.4 and 3.2.4.1.5 of MS-SMB2 */
   113          if ((tcon->ses) &&
   114              (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
                     ^^^^^^^^^^^^^^^^^
Dereferenced without a check.

   115                  hdr->CreditCharge = cpu_to_le16(1);
   116          /* else CreditCharge MBZ */
   117  
   118          hdr->TreeId = tcon->tid;
   119          /* Uid is not converted */
   120          if (tcon->ses)
   121                  hdr->SessionId = tcon->ses->Suid;
   122  
   123          /*
   124           * If we would set SMB2_FLAGS_DFS_OPERATIONS on open we also would have
   125           * to pass the path on the Open SMB prefixed by \\server\share.
   126           * Not sure when we would need to do the augmented path (if ever) and
   127           * setting this flag breaks the SMB2 open operation since it is
   128           * illegal to send an empty path name (without \\server\share prefix)
   129           * when the DFS flag is set in the SMB open header. We could
   130           * consider setting the flag on all operations other than open
   131           * but it is safer to net set it for now.
   132           */
   133  /*      if (tcon->share_flags & SHI1005_FLAGS_DFS)
   134                  hdr->Flags |= SMB2_FLAGS_DFS_OPERATIONS; */
   135  
   136          if (tcon->ses && tcon->ses->server && tcon->ses->server->sign)
                                 ^^^^^^^^^^^^^^^^^

Checked too late.

   137                  hdr->Flags |= SMB2_FLAGS_SIGNED;
   138  out:
   139          pdu->StructureSize2 = cpu_to_le16(parmsize);
   140          return;

regards,
dan carpenter
