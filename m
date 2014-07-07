From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: cifs: Split lanman auth from CIFS_SessSetup()
Date: Mon, 7 Jul 2014 14:41:26 +0300
Message-ID: <20140707114126.GA21109@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Sachin Prabhu,

The patch 4b26c7b1fc36: "cifs: Split lanman auth from
CIFS_SessSetup()" from Jun 16, 2014, leads to the following static
checker warning:

	fs/cifs/sess.c:797 CIFS_SessSetup()
	warn: possible memory leak of 'sess_data'

fs/cifs/sess.c
   784          sess_data = kzalloc(sizeof(struct sess_data), GFP_KERNEL);
   785          if (!sess_data)
   786                  return -ENOMEM;
   787          sess_data->xid = xid;
   788          sess_data->ses = ses;
   789          sess_data->buf0_type = CIFS_NO_BUFFER;
   790          sess_data->nls_cp = (struct nls_table *) nls_cp;
   791  
   792          type = select_sectype(ses->server, ses->sectype);
   793          cifs_dbg(FYI, "sess setup type %d\n", type);
   794          if (type == Unspecified) {
   795                  cifs_dbg(VFS,
   796                          "Unable to select appropriate authentication method!");
   797                  return -EINVAL;
                        ^^^^^^^^^^^^^^
missing kfree().

   798          }

regards,
dan carpenter
