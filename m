From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] cifs: refactor mid finding loop in cifs_demultiplex_thread
Date: Tue, 3 May 2011 09:50:46 -0500
Message-ID: <BANLkTik7rJr=JetDXJrd8E6smCmobWLE4A@mail.gmail.com>
References: <1303819401-14789-1-git-send-email-jlayton@redhat.com>
	<1303819401-14789-5-git-send-email-jlayton@redhat.com>
	<BANLkTim4jXoQm47-ecw8r5ftBVGRbA+mKw@mail.gmail.com>
	<20110503080953.65db9af6@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110503080953.65db9af6-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, May 3, 2011 at 7:09 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, 2 May 2011 22:44:42 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> From this series all but the cifs: remove unneeded variable
>> initialization in cifs_r... (which doesn't need to go in 2.6.39) look
>> fine and are merged.
>>
>
> Thanks Steve,
>
> Any idea when you'll update your for-2.6.40 branch? I have some patches
> that are based on that branch that will probably need to be respun
> now...

I have the current patches for 2.6.40 in "for-next" branch in cifs-2.6.git.



-- 
Thanks,

Steve
