From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: RE: [PATCH] cifs: set client time as MsvAvTimestamp from
 CHALLENGE_MESSAGE.TargetInfo
Date: Tue, 26 Aug 2014 09:19:32 +0900
Message-ID: <000b01cfc0c3$68a233d0$39e69b70$@samsung.com>
References: <001301cfc025$940767f0$bc1637d0$@samsung.com>
 <1408972359.11134.26.camel@pico.ipa.ssimo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: 'Steve French' <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	'Jeff Layton' <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	'Ashish Sangwan' <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: 'Simo' <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1408972359.11134.26.camel-fj0lwfvWodpMy5p6ylGyhR2eb7JE58TQ@public.gmane.org>
Content-language: ko
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


> > +
> >  int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
> >  				    struct cifs_ses *ses)
> >  {
> > @@ -322,6 +342,7 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
> >  			return -ENOMEM;
> >  		}
> >  		ses->auth_key.len = tilen;
> > +		get_ntlmv2_server_time(ses);
> >  	}
> >
> >  	return 0;
> 
> I'll let a cifs maintainer ack or nack the implementation, but from a
> logic pov it looks good.
Thanks for your review!
> 
> Simo.
