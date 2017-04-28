From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cifs: small underflow in cnvrtDosUnixTm()
Date: Fri, 28 Apr 2017 17:41:29 +0300
Message-ID: <20170428144129.3v3fcz5oldjtmymx@mwanda>
References: <20170428125130.4y22bpllksfyb37k@mwanda>
 <59035444.6090305@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: walter harms <wharms-fPG8STNUNVg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <59035444.6090305-fPG8STNUNVg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Apr 28, 2017 at 04:40:04PM +0200, walter harms wrote:
> 
> 
> Am 28.04.2017 14:51, schrieb Dan Carpenter:
> > January is month 1.  There is no zero-th month.  If someone passes a
> > zero month then it means we read from one space before the start of the
> > total_days_of_prev_months[] array.
> > 
> > We may as well also be strict about days as well.
> > 
> > Fixes: 1bd5bbcb6531 ("[CIFS] Legacy time handling for Win9x and OS/2 part 1")
> > Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> > v2:  Be strict about days as well.  My first patch was less intrusive
> > because it only prevented the out of bounds access.  I have no idea how
> > common it is to pass in an illegal day but, hopefully, not very common.
> > 
> > diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> > index abae6dd2c6b9..4b2726ee4fad 100644
> > --- a/fs/cifs/netmisc.c
> > +++ b/fs/cifs/netmisc.c
> > @@ -980,10 +980,10 @@ struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
> >  		cifs_dbg(VFS, "illegal hours %d\n", st->Hours);
> >  	days = sd->Day;
> >  	month = sd->Month;
> > -	if ((days > 31) || (month > 12)) {
> > +	if (days < 1 || days > 31 || month < 1 || month > 12) {
> >  		cifs_dbg(VFS, "illegal date, month %d day: %d\n", month, days);
> > -		if (month > 12)
> > -			month = 12;
> > +		days = (days < 1) ? 1 : ((days <= 31) ? days : 31);
> > +		month = (month < 1) ? 1 : ((month <= 12) ? month : 12);
> >  	}
> >  	month -= 1;
> >  	days += total_days_of_prev_months[month];
> 
> The mixing in now a bit unfortunate ... why not simply
> 
> 	if (days < 1 || days > 31 || month < 1 || month > 12)
> 		cifs_dbg(VFS, "illegal date, month %d day: %d\n", month, days);
> 
> 	month = (month < 1) ? 1 : ((month <= 12) ? month : 12);
> 	days = (days < 1) ? 1 : ((days <= 31) ? days : 31);
> 

I prefer my version because I feel like it more closely expresses what
I want to say.

regards,
dan carpenter
