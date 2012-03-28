From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: cifs: use standard token parser for mount options
Date: Wed, 28 Mar 2012 13:45:41 +0300
Message-ID: <20120328104541.GC29022@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Sachin Prabhu,

This is a semi-automatic email about new static checker warnings.

The patch 8830d7e07a5e: "cifs: use standard token parser for mount 
options" from Mar 23, 2012, leads to the following Smatch complaint:

fs/cifs/connect.c:1607 cifs_parse_mount_options()
	 error: we previously assumed 'value' could be null (see line 1568)

fs/cifs/connect.c
  1567				value = strchr(data, '=');
  1568				if (value != NULL)
                                    ^^^^^^^^^^^^^
Check.

  1569					*value++ = '\0';
  1570	
  1571				/* Set tmp_end to end of the string */
  1572				tmp_end = (char *) value + strlen(value);
                                                                  ^^^^^
We can't run strlen() on NULL pointers.

  1573	
  1574				/* Check if following character is the deliminator

regards,
dan carpenter
