From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] CIFS: Implement follow_link for SMB2
Date: Tue, 12 Jul 2016 16:55:07 +0300
Message-ID: <20160712135507.GA30732@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Pavel Shilovsky,

The patch b42bf88828cd: "CIFS: Implement follow_link for SMB2" from
Aug 14, 2013, leads to the following static checker warning:

	fs/cifs/smb2pdu.c:1408 SMB2_open()
	warn: potentially allocating too little.  77 vs 4

fs/cifs/smb2pdu.c
  1402          rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
  1403          rsp = (struct smb2_create_rsp *)iov[0].iov_base;
  1404  
  1405          if (rc != 0) {
  1406                  cifs_stats_fail_inc(tcon, SMB2_CREATE_HE);
  1407                  if (err_buf)
  1408                          *err_buf = kmemdup(rsp, get_rfc1002_length(rsp) + 4,

I'm not an expert, but these look like it might be controlled from user
space.  How do we know that get_rfc1002_length() returns something large
enough?

  1409                                             GFP_KERNEL);
  1410                  goto creat_exit;
  1411          }
  1412  

regards,
dan carpenter
