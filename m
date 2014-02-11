From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Problem with Samba re-share of a CIFS mount
Date: Tue, 11 Feb 2014 12:01:50 -0600
Message-ID: <CAH2r5mvQ590zaniv3cDuu+Do0N9TePasTaEFkrNSAdatTiaZ5Q@mail.gmail.com>
References: <52F9EDA5.1020004@assyoma.it> <20140211103302.6d74b90d@tlielax.poochiereds.net>
 <52FA46D5.8020904@assyoma.it> <20140211124536.5fdcb56f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	James McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140211124536.5fdcb56f-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Feb 11, 2014 at 11:45 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 11 Feb 2014 16:50:45 +0100
> Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org> wrote:
>
>> Hi Jeff,
>> I had the same idea.
>>
>> When mounting the CIFS directory, the problematic installations return 0
>> links for both dirs and files. On the other hand, the stock CentOS
>> installation return 1 or more links.
>>
>> It puzzled me. Two questions:
>> - anyone know the rationale behind this?
>
> The rationale is that windows servers always send a NumberOfLinks value
> of '0' for directories. We have a hack in place that went in around a
> year ago to work around that for (arguably broken) applications that
> try to infer something about an inode that has a zero st_nlink value.
>
>> - how it is possible to work-around that with an unpatched kernel?
>>
>
> There is no workaround. Either fix the application such that it doesn't
> care or patch the kernel. I'll cc Jim since he did a fair bit of
> looking at this several months ago.
>
> In truth though, resharing a cifs mount is probably not a great
> solution. It sounds like the kind of setup that's going to end up being
> fraught with cache coherency problems...

Problem is that there are situations where it is required (usually
due to legacy dialect support or due to legacy authentication
support).

I am not as worried about the cache coherence issues if
we are mounting "cache=none" and we can even set
actimeo lower if needed

-- 
Thanks,

Steve
