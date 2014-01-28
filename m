From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs: Re-order M-F Symlink code
Date: Tue, 28 Jan 2014 13:17:20 +0000
Message-ID: <1390915040.3984.11.camel@sachin-laptop>
References: <20140127204856.GA3089@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140127204856.GA3089-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2014-01-27 at 23:48 +0300, Dan Carpenter wrote:
> Hello Sachin Prabhu,
> 
> The patch 0f8dce1cb745: "cifs: Re-order M-F Symlink code" from Nov
> 25, 2013, leads to the following static checker warning:
> 
> 	fs/cifs/link.c:188 couldbe_mf_symlink()
> 	error: should you be using something like S_ISREG() here?
> 
> fs/cifs/link.c
>    185  bool
>    186  couldbe_mf_symlink(const struct cifs_fattr *fattr)
>    187  {
>    188          if (!(fattr->cf_mode & S_IFREG))
>                                        ^^^^^^
> Should this be:
> 
> 		if (!S_ISREG(fattr->cf_mode))
> 
>    189                  /* it's not a symlink */
>    190                  return false;
>    191  
>    192          if (fattr->cf_eof != CIFS_MF_SYMLINK_FILE_SIZE)
>    193                  /* it's not a symlink */
>    194                  return false;
>    195  
>    196          return true;
>    197  }
> 
> If this a real bug then please give the credit to Neil Brown because he
> suggested I add this to Smatch (not pushed yet).
> 
> Reported-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> 
> regards,
> dan carpenter

Hello Dan,

There seems to be no difference in operation between the original line
and the proposed line. The newer line just seems to be the preferred way
to test for regular files. Is there a bug I am missing here?

That particular line of code was simply copied over from the original
code it replaces.

You could propose a new patch for the change if you wish and I will be
happy to ack.

Sachin Prabhu
