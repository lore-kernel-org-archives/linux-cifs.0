From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: cifs: fetch credentials out of keyring for non-krb5 auth
 multiuser mounts
Date: Fri, 20 Jan 2012 11:21:32 +0300
Message-ID: <20120120082132.GA21512@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Jeff,

The patch 8a8798a5ff90: "cifs: fetch credentials out of keyring for 
non-krb5 auth multiuser mounts" from Jan 17, 2012, has a problem here:

+       upayload = key->payload.data;
+       if (IS_ERR_OR_NULL(upayload)) {
+               rc = PTR_ERR(key);
                             ^^^
"key" is a valid pointer not an ERR_PTR.  Also "upayload" can be NULL
and PTR_ERR(NULL) is success.

+               goto out_key_put;
+       }

regards,
dan carpenter
