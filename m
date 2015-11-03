From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: Send durable handle v2 contexts when use of persistent handles
 required
Date: Tue, 3 Nov 2015 14:47:29 +0300
Message-ID: <20151103114729.GA18287@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Steve French,

The patch ea81d9ba9d72: "Send durable handle v2 contexts when use of
persistent handles required" from Oct 3, 2015, leads to the following
static checker warning:

	fs/cifs/smb2pdu.c:1156 create_durable_v2_buf()
	warn: struct type mismatch 'create_durable_v2 vs create_durable'

fs/cifs/smb2pdu.c
  1151  static struct create_durable_v2 *
  1152  create_durable_v2_buf(struct cifs_fid *pfid)
  1153  {
  1154          struct create_durable_v2 *buf;
  1155  
  1156          buf = kzalloc(sizeof(struct create_durable), GFP_KERNEL);

I think this is a problem, isn't create_durable_v2 larger?  Smatch is
bad at calculating the sizes of enums.

  1157          if (!buf)
  1158                  return NULL;
  1159  

regards,
dan carpenter
