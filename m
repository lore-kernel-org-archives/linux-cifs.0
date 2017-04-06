From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] Handle mismatched open calls
Date: Thu, 6 Apr 2017 12:11:36 +0300
Message-ID: <20170406091021.GA28584@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Sachin Prabhu,

The patch 96b75d0508f8: "Handle mismatched open calls" from Mar 3,
2017, leads to the following static checker warning:

	fs/cifs/cifssmb.c:1530 cifs_readv_receive()
	error: potential NULL dereference 'server->smallbuf'.

fs/cifs/cifssmb.c
  1519          cifs_dbg(FYI, "0: iov_base=%p iov_len=%u\n",
  1520                   rdata->iov[0].iov_base, server->total_read);
  1521  
  1522          mid->resp_buf = server->smallbuf;
  1523          server->smallbuf = NULL;
                ^^^^^^^^^^^^^^^^^^^^^^^
We set this to NULL here

  1524  
  1525          /* how much data is in the response? */
  1526          data_len = server->ops->read_data_length(buf);
  1527          if (data_offset + data_len > buflen) {
  1528                  /* data_len is corrupt -- discard frame */
  1529                  rdata->result = -EIO;
  1530                  return cifs_readv_discard(server, mid);
                                                  ^^^^^^
but we need it here.

  1531          }
  1532  
  1533          length = rdata->read_into_pages(server, rdata, data_len);
  1534          if (length < 0)
  1535                  return length;

regards,
dan carpenter
