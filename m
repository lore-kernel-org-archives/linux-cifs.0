From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: Does linux smb2 client supports DFS capability?
Date: Thu, 12 Oct 2017 10:41:24 +0200
Message-ID: <mpswp4092rv.fsf@aaptelpc.suse.de>
References: <FBFAFA79-EEBE-4F0F-B898-19D2A8096E62@nutanix.com> <mpsk2a4l69q.fsf@suse.com> <B4C283AF-91A2-435A-85A6-DAE11A90DB6D@nutanix.com> <mpszi8x9a8i.fsf@aaptelpc.suse.de> <CAH2r5muEvnMZT9L-hvO-7o=fsaRU28KZEJA+3dgzmNyn4nVH5Q@mail.gmail.com> <CACyXjPzwUx4T7DnvtX55PrtAE9Tj1iPryZNhfStDWkGW3JrDDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-cifs\@vger.kernel.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Hemanth Thummala <hemanth.thummala-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org>
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPzwUx4T7DnvtX55PrtAE9Tj1iPryZNhfStDWkGW3JrDDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> I think their real interest is in the CIFS FS getting DFS referrals if
> STATUS_PATH_NOT_COVERED is returned on a CREATE.
>
> When I last looked the client could not do that.

cifs.ko should be able to traverse a DFS link on the FS, after the DFS
mounted. My testing setup when I worked on this was the following:

//A/root
       |
       +- link -> //B/target
       +- sublink -> //B/target/sub

//B/target
       |
       + sub/
          |
          + dir/
              |
              + files..

And I had a script
- mounting //A/root and running cd&ls in /, /link, /link/sub,
  /link/sub/dir, /sublink, /sublink/dir
- mounting //A/root/link and running cd&ls in /, /sub, /sub/dir
- mounting //A/root/link/sub and running cd&ls in /, /dir
- mounting //A/root/sublink and running cd&ls in /, /dir
- mounting //A/root/sublink/dir and running cd&ls in /

And all worked for vers={1.0,3.0}, A being {samba, Windows Server 2016},
B being {samba, Windows Server 2012 R2} when I submitted the patches.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
