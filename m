From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: [CIFS] Charge at least one credit, if server says that it
 supports multicredit
Date: Mon, 24 Jun 2013 15:24:49 +0300
Message-ID: <20130624122449.GA14149@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Steve French,

This is a semi-automatic email about new static checker warnings.

The patch 7f420cee8bd6: "[CIFS] Charge at least one credit, if server
says that it supports multicredit" from Jun 23, 2013, leads to the
following Smatch complaint:

fs/cifs/smb2pdu.c:120 smb2_hdr_assemble()
	 warn: variable dereferenced before check 'tcon->ses' (see line 115)

fs/cifs/smb2pdu.c
   114		if (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU)
                    ^^^^^^^^^^^
New dereference.

   115			hdr->CreditCharge = cpu_to_le16(1);
   116		/* else CreditCharge MBZ */
   117	
   118		hdr->TreeId = tcon->tid;
   119		/* Uid is not converted */
   120		if (tcon->ses)
                    ^^^^^^^^^
Old check.

   121			hdr->SessionId = tcon->ses->Suid;
   122		/* BB check following DFS flags BB */

regards,
dan carpenter
