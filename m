From: Seth Forshee <seth.forshee@canonical.com>
Subject: cifs mount regression in 4.8 and 4.4 stable
Date: Thu, 22 Sep 2016 10:09:18 -0500
Message-ID: <20160922150918.GA127053@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sachin Prabhu <sprabhu@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
To: Steve French <sfrench@samba.org>, Aurelien Aptel <aaptel@suse.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

We've received reports from users of a cifs mount regression in our
4.4-based kernel, e.g. [1]. It is fixed by reverting the follwing commit
from 4.8 which was applied to 4.4 stable:

 a6b5058 fs/cifs: make share unaccessible at root level mountable

Testing against 4.8-rc7 shows that the problem is present there as well.

Thanks,
Seth

[1] http://bugs.launchpad.net/bugs/1626112
