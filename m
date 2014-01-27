From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: cifs: Re-order M-F Symlink code
Date: Mon, 27 Jan 2014 23:48:56 +0300
Message-ID: <20140127204856.GA3089@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
To: sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Sachin Prabhu,

The patch 0f8dce1cb745: "cifs: Re-order M-F Symlink code" from Nov
25, 2013, leads to the following static checker warning:

	fs/cifs/link.c:188 couldbe_mf_symlink()
	error: should you be using something like S_ISREG() here?

fs/cifs/link.c
   185  bool
   186  couldbe_mf_symlink(const struct cifs_fattr *fattr)
   187  {
   188          if (!(fattr->cf_mode & S_IFREG))
                                       ^^^^^^
Should this be:

		if (!S_ISREG(fattr->cf_mode))

   189                  /* it's not a symlink */
   190                  return false;
   191  
   192          if (fattr->cf_eof != CIFS_MF_SYMLINK_FILE_SIZE)
   193                  /* it's not a symlink */
   194                  return false;
   195  
   196          return true;
   197  }

If this a real bug then please give the credit to Neil Brown because he
suggested I add this to Smatch (not pushed yet).

Reported-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>

regards,
dan carpenter
