From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SMB2 delete problem
Date: Tue, 26 Oct 2010 23:22:48 -0500
Message-ID: <AANLkTikAQ8ma82ewk4nU4UtKeHX4JUT_=HwX7t5thbj=@mail.gmail.com>
References: <AANLkTimbdp0zJHp4AiryteCmYhz6mvJVWm2yp4NZoKrH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimbdp0zJHp4AiryteCmYhz6mvJVWm2yp4NZoKrH-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into smb2.git - but it looks like it is missing a d_drop for
the case where the file was deleted on the server by another client
between the lookup and delete (where we get ENOENT).

On Tue, Oct 26, 2010 at 12:54 PM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi!
>
> I faced with the problem that the client decrements dentry's d_count
> more that increments and it causes the error ''dentry still in use" on
> umount. I created the patch that solves this.
>
> --
> Best regards,
> Pavel Shilovsky.
>



-- 
Thanks,

Steve
