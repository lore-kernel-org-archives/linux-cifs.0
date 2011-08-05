From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: cope with negative dentries in cifs_get_root
Date: Fri, 5 Aug 2011 10:03:49 -0500
Message-ID: <CAH2r5mtXKWixzpaJMaqx8sDzp=x7ch3drzg_o=KX4Tder3hVPQ@mail.gmail.com>
References: <1312549360-4317-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: viro@zeniv.linux.org.uk, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1312549360-4317-1-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, Aug 5, 2011 at 8:02 AM, Jeff Layton <jlayton@redhat.com> wrote:
> The loop around lookup_one_len doesn't handle the case where it might
> return a negative dentry, which can cause an oops on the next pass
> through the loop. Check for that and break out of the loop with an
> error of -ENOENT if there is one.
>

merged into cifs-2.6.git

-- 
Thanks,

Steve
